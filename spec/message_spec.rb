require 'spec_helper'

describe ContextIO::Message do
  before(:each) do
    @fixtures_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
    account_id = 'abcdef1234567890'
    @account = ContextIO::Account.new
    @account.instance_eval do
      @id = account_id
    end
    @messages_url = "https://api.context.io/2.0/accounts/#{account_id}/messages"

  end

  describe '.all' do
    before(:each) do
      json_messages = File.read(File.join(@fixtures_path, 'messages.json'))
      @response = stub_request(:get, @messages_url).
        to_return(:body => json_messages)
    end

    it 'returns an array of Message objects for given account ID' do
      messages = ContextIO::Message.all(@account.id)
      messages.should be_a(Array)
      messages.first.should be_a(ContextIO::Message)
    end

    it 'returns an array of Message objects for given Account object' do
      messages = ContextIO::Message.all(@account)
      messages.should be_a(Array)
      messages.first.should be_a(ContextIO::Message)
    end

    it 'returns empty array when no account is given' do
      messages = ContextIO::Message.all(nil)
      messages.should be_a(Array)
      messages.length.should == 0
    end

    it 'calls the API method' do
      ContextIO::Message.all(@account)
      @response.should have_been_requested
    end

    it 'sets attributes of Message object' do
      msg = ContextIO::Message.all(@account).first
      msg.message_id.should == '4f0f1c533f757e0f3c00000b'
      msg.subject.should == 'Get Gmail on your mobile phone'
      msg.from['name'].should == 'Gmail Team'
      msg.to.length.should == 1
    end

    it 'sends query' do
      q = {
        :subject => 'Some subject',
        :email => 'james@example.net',
        :to => 'james@example.com',
        :limit => '30',
        :offset => '30'
      }

      @response = @response.with(:query => q)

      ContextIO::Message.all(@account, q)
      @response.should have_been_requested
    end
  end

  describe 'message flags' do
    before(:each) do
      json_messages = File.read(File.join(@fixtures_path, 'messages.json'))
      @response = stub_request(:get, @messages_url).
        to_return(:body => json_messages)
    end

    it 'retrieves flags' do
      msg_id = '4f0f1c533f757e0f3c00000b'
      flags_response = stub_request(:get, "#{@messages_url}/#{msg_id}/flags").
        to_return(:body => {"answered"=>false, "draft"=>false, "deleted"=>false, "seen"=>true, "flagged"=>false}.to_json)
      flags = ContextIO::Message.all(@account).first.flags
      flags.should be_a(Hash)
      flags['seen'].should == true
    end
  end

  describe 'thread' do
    before(:each) do
      json_messages = File.read(File.join(@fixtures_path, 'messages.json'))
      thread_messages = "{\"messages\": #{json_messages}}"
      stub_request(:get, @messages_url).to_return(:body => json_messages)
      msg_id = '4f0f1c533f757e0f3c00000b'
      @response = stub_request(:get, "#{@messages_url}/#{msg_id}/thread").
        to_return(:body => thread_messages)
    end

    it 'returns array of Message objects' do
      thread = ContextIO::Message.all(@account).first.thread
      thread.should be_a(Array)
      thread.first.should be_a(ContextIO::Message)
    end

    it 'calls API method' do
      ContextIO::Message.all(@account).first.thread
      @response.should have_been_requested
    end
  end

  describe 'body and headers lazy loading' do
    before(:each) do
      msg_id = '4f0f1c533f757e0f3c00000b'
      body = '[
        {
          "type": "text/plain",
          "content":"Just a message"
        },
        {
          "type": "text/html",
          "content": "<html><p>Just a message</p></html>"
        }]'
      headers = '{"Received":"by 10.10.1.1"}'
      json_messages = File.read(File.join(@fixtures_path, 'messages.json'))
      stub_request(:get, @messages_url).
        to_return(:body => json_messages)
      @body_resp = stub_request(:get, "#{@messages_url}/#{msg_id}/body").
        to_return(:body => body)
      @headers_resp = stub_request(:get, "#{@messages_url}/#{msg_id}/headers").
        to_return(:body => headers)
    end

    it 'requests body on first access' do
      msg = ContextIO::Message.all(@account).first
      msg.body.should == 'Just a message'
      msg.body('html').start_with?('<html>').should be_true
      @body_resp.should have_been_requested
    end

    it 'does not request body on second request' do
      msg = ContextIO::Message.all(@account).first
      msg.body
      msg.body
      @body_resp.should have_been_made.once
    end

    it 'requests headers' do
      msg = ContextIO::Message.all(@account).first
      msg.headers.should be_a(Hash)
      msg.headers['Received'].should == 'by 10.10.1.1'
      @headers_resp.should have_been_requested
    end

    it 'does not request headers on second request' do
      msg = ContextIO::Message.all(@account).first
      msg.headers
      msg.headers
      @headers_resp.should have_been_made.once
    end
  end

  describe "copy" do
    before(:each) do
      msgs = MultiJson.decode(File.read(File.join(@fixtures_path, 'messages.json')))
      @message = ContextIO::Message.from_json(@account.id, msgs.first)
      copy_options = {:dst_folder => "Important", :move => '0'}
      copy_to_source = {:dst_folder => "Important", :dst_source => "Other Source", :move => '0'}
      @copy_response = stub_request(:post, "#{@messages_url}/#{@message.message_id}").
        with(:body => copy_options)
      @copy_to_source_response = stub_request(:post, "#{@messages_url}/#{@message.message_id}").
        with(:body => copy_to_source)
    end

    it 'raises ArgumentError for empty target folder' do
      lambda { @message.copy(nil) }.should raise_error ArgumentError
    end
    
    it "copy calls API method with copy options" do
      @message.copy("Important")
      @copy_response.should have_been_requested
    end

    it "copy to source calls API method with source in post arguments" do
      @message.copy("Important", "Other Source")
      @copy_to_source_response.should have_been_requested
    end
  end

  describe "move" do
    before(:each) do
      msgs = MultiJson.decode(File.read(File.join(@fixtures_path, 'messages.json')))
      @message = ContextIO::Message.from_json(@account.id, msgs.first)
      move_options = {:dst_folder => "Important", :move => '1'}
      @move_response = stub_request(:post, "#{@messages_url}/#{@message.message_id}").
        with(:body => move_options)
    end

    it 'raises ArgumentError for empty target folder' do
      lambda { @message.move(nil) }.should raise_error ArgumentError
    end

    it "move calls API method with move options" do
      @message.move("Important")
      @move_response.should have_been_requested
    end
  end
  
  describe '.find' do
    before(:each) do
      @messages = MultiJson.decode(File.read(File.join(@fixtures_path, 'messages.json')))
      @find_url = "#{@messages_url}/#{@messages.first['message_id']}"
      @response = stub_request(:get, @find_url).
        to_return(:body => MultiJson.encode(@messages.first))
    end

    it 'calls API method' do
      ContextIO::Message.find(@account, @messages.first['message_id'])
      @response.should have_been_requested
    end

    it 'returns single message for given ID' do
      msg = ContextIO::Message.find(@account, @messages.first['message_id'])
      msg.should be_a(ContextIO::Message)
      msg.message_id.should == @messages.first['message_id']
    end
  end
end
