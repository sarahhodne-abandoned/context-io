require "spec_helper"

describe ContextIO::Source do
  before(:each) do
    @fixtures_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
    account_id = 'abcdef1234567890'
    @account = ContextIO::Account.new
    @account.instance_eval do
      @id = account_id
    end
    @sources_url = "https://api.context.io/2.0/accounts/#{account_id}/sources"
    @existing_src = ContextIO::Source.new(@account.id, {'label' => 'me.example.com::imap.example.com',
        'email' => 'me@example.com', 'server' => 'imap.example.com',
        'username' => "me", 'use_ssl' => true, 'port' => '', 'type' => 'IMAP'})
  end

  describe ".new" do
    it "raises ArgumentError for empty account ID" do
      lambda { ContextIO::Source.new(nil) }.should raise_error ArgumentError
    end

    it "sets attributes of Source object" do
      src = ContextIO::Source.new(@account.id,
        {"label" => "bi@example.com::imap.example.com",
          "email" => "bi@example.com",
          "authentication_type" => "oauth"})
      src.account_id.should == @account.id
      src.label.should == "bi@example.com::imap.example.com"
      src.email.should == "bi@example.com"
      src.authentication_type.should == "oauth"
    end
  end
  
  describe ".all" do
    before(:each) do
      json_sources = File.read(File.join(@fixtures_path, 'sources.json'))
      @response = stub_request(:get, @sources_url).
        to_return(:body => json_sources)
    end

    it 'returns an array of Source objects for given account ID' do
      sources = ContextIO::Source.all(@account.id)
      sources.should be_a(Array)
      sources.first.should be_a(ContextIO::Source)
    end

    it 'returns an array of Soruce objects for given Account object' do
      sources = ContextIO::Source.all(@account)
      sources.should be_a(Array)
      sources.first.should be_a(ContextIO::Source)
    end

    it 'returns empty array when no account is given' do
      sources = ContextIO::Source.all(nil)
      sources.should be_a(Array)
      sources.length.should == 0
    end

    it 'calls the API method' do
      ContextIO::Source.all(@account)
      @response.should have_been_requested
    end

    it 'sets attributes of Source object' do
      src = ContextIO::Source.all(@account).first
      src.label.should == 'bi@example.com::imap.example.com'
      src.authentication_type.should == 'oauth'
      src.port == 993
      src.service_level.should == 'pro'
      src.username.should == 'bi@example.com'
      src.server.should == 'imap.example.com'
      src.source_type.should == 'imap'
      src.sync_period.should == '1d'
      src.use_ssl.should be_true
      src.status.should == 'OK'
    end

    it 'sends query' do
      q = {
        :status => 'INVALID_CREDENTIALS',
        :status_ok => '1'
      }

      @response = @response.with(:query => q)

      ContextIO::Source.all(@account, q)
      @response.should have_been_requested
    end
  end
  
  describe '.find' do
    before(:each) do
      @sources = MultiJson.decode(File.read(File.join(@fixtures_path, 'sources.json')))
      @find_url = "#{@sources_url}/#{@sources.first['label']}"
      @response = stub_request(:get, @find_url).
        to_return(:body => MultiJson.encode(@sources.first))
    end

    it 'calls API method' do
      ContextIO::Source.find(@account, @sources.first['label'])
      @response.should have_been_requested
    end

    it 'returns single source for given label' do
      src = ContextIO::Source.find(@account, @sources.first['label'])
      src.should be_a(ContextIO::Source)
      src.label.should == @sources.first['label']
    end
  end

  describe '#save' do
    it 'returns true if the save was successful' do
      @stub = stub_request(:post, "https://api.context.io/2.0/accounts/#{@account.id}/sources").
        with(:body => { :email => 'me@example.com', :server => 'imap@example.com',
        :username => "me", :use_ssl => 'true', :port => '143', :type => 'IMAP'}).
        to_return(
        :body => '{
          "success": true
        }'
      )

      src = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => 'imap@example.com',
          'username' => "me", 'use_ssl' => true, 'port' => 143, 'type' => 'IMAP'})

      src.save.should be_true
    end

    it 'returns false if the save was not successful' do
      @stub = stub_request(:post, "https://api.context.io/2.0/accounts/#{@account.id}/sources").
        with(:body => { :email => 'me@example.com', :server => 'imap@example.com',
        :username => "me", :use_ssl => 'true', :port => '143', :type => 'IMAP'}).
        to_return(
        :body => '{
          "success": false
        }'
      )

      src = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => 'imap@example.com',
          'username' => "me", 'use_ssl' => true, 'port' => 143, 'type' => 'IMAP'})

      src.save.should be_false
    end

    it 'raises ArgumentError if mandatory arguments are missing' do
      src = ContextIO::Source.new(@account.id, {'email' => '', 'server' => 'imap@example.com',
          'username' => "me", 'use_ssl' => true, 'port' => '143', 'type' => 'IMAP'})
      lambda { src.save }.should raise_error ArgumentError

      src = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => '',
          'username' => "me", 'use_ssl' => true, 'port' => '143', 'type' => 'IMAP'})
      lambda { src.save }.should raise_error ArgumentError

      src = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => '',
          'username' => '', 'use_ssl' => true, 'port' => '143', 'type' => 'IMAP'})
      lambda { src.save }.should raise_error ArgumentError

      src = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => '',
          'username' => "me", 'use_ssl' => true, 'port' => '', 'type' => 'IMAP'})
      lambda { src.save }.should raise_error ArgumentError
    end
  end

  describe '#update_attributes' do
    it 'calls the API request' do
      @stub = stub_request(:post, "#{@sources_url}/#{@existing_src.label}").
        with(:body => { 'sync_period' => '1d' }).
        to_return(
        :body => '{
          "success": true
        }'
      )

      @existing_src.update_attributes("sync_period" => '1d')

      @stub.should have_been_requested
    end

    it 'returns true if the update was successful' do
      stub_request(:post, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": true}'
      )

      @existing_src.update_attributes('status' => 'OK').should be_true
    end

    it 'returns false if the update was unsuccessful' do
      stub_request(:post, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": false}'
      )

      @existing_src.update_attributes('status' => 'OK').should be_false
    end

    it 'sets the attributes on the Source object' do
      stub_request(:post, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": true}'
      )

      @existing_src.update_attributes('service_level' => 'test_level')

      @existing_src.service_level.should == 'test_level'
    end
  end

  describe "#destroy" do
    it 'calls the API request' do
      @stub = stub_request(:delete, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": true}'
      )

      @existing_src.destroy

      @stub.should have_been_requested
    end

    it 'returns true if destroy is successful' do
      stub_request(:delete, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": true}'
      )

      @existing_src.destroy.should be_true
    end

    it 'resets source label if destroy is successful' do
      stub_request(:delete, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": true}'
      )

      @existing_src.destroy
      @existing_src.label.should == ''
    end

    it 'returns false if destroy is not successful' do
      stub_request(:delete, "#{@sources_url}/#{@existing_src.label}").
        to_return(
        :body => '{"success": false}'
      )

      @existing_src.destroy.should be_false
    end
  end
end
