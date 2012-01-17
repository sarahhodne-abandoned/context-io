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
      src.type.should == 'imap'
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
end
