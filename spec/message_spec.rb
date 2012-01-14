require "spec_helper"

describe ContextIO::Message do
  before(:each) do
    @fixtures_path = File.expand_path(File.join(File.dirname(__FILE__), "fixtures"))
    @account_id = 5
    @account = ContextIO::Account.new
    @account.id = @account_id
    @messages_url = "https://api.context.io/2.0/accounts/#{@account_id}/messages"
    
  end
  
  describe ".all" do
    before(:each) do
      json_messages = File.read(File.join(@fixtures_path, "messages.json"))
      @response = stub_request(:get, @messages_url).to_return(:body => json_messages)
    end
    
    it 'retunrs an array of Message objects for given account ID' do
      messages = ContextIO::Message.all(@account.id)
      messages.should be_a(Array)
      messages.first.should be_a(ContextIO::Message)
    end

    it 'retunrs an array of Message objects for given Account object' do
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
      msg.from["name"].should == "Gmail Team"
      msg.to.length.should == 1
    end

    it 'sends query' do
      q = {
        :subject => "Some subject",
        :email => "james@example.net",
        :to => "james@example.com",
        :limit => '30',
        :offset => '30'
      }
      
      @response = @response.with(:query => q)

      ContextIO::Message.all(@account, q)
      @response.should have_been_requested
    end

    it 'retrieves flags' do
      msg_id = '4f0f1c533f757e0f3c00000b'
      flags_response = stub_request(:get, "#{@messages_url}/#{msg_id}/flags").to_return(:body => ["\\Seen"].to_json)
      flags = ContextIO::Message.all(@account).first.flags
      flags.should be_a(Array)
      flags.first.should == "\\Seen"
    end
    
    context 'body and headers lazy loading' do
      before(:each) do
        msg_id = '4f0f1c533f757e0f3c00000b'
        body = "[{\"type\":\"text/plain\",\"content\":\"Just a message\"},{\"type\":\"text/html\",\"content\":\"<html><p>Just a message</p></html>\"}]"
        headers = "{\"Received\":\"by 10.10.1.1\"}"
        @body_resp = stub_request(:get, "#{@messages_url}/#{msg_id}/body").to_return(:body => body)
        @headers_resp = stub_request(:get, "#{@messages_url}/#{msg_id}/headers").to_return(:body => headers)
      end
      
      it 'requests body' do
        msg = ContextIO::Message.all(@account).first
        msg.body.should == "Just a message"
        msg.body("html").start_with?("<html>").should be_true
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
        msg.headers["Received"].should == "by 10.10.1.1"
        @headers_resp.should have_been_requested
      end

      it 'does not request headers on second request' do
        msg = ContextIO::Message.all(@account).first
        msg.headers
        msg.headers
        @headers_resp.should have_been_made.once
      end
    end
  end
end
