require 'spec_helper'

describe ContextIO::File do
  before(:each) do
    @fixtures_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
    account_id = 'abcdef1234567890'
    @account = ContextIO::Account.new
    @account.instance_eval do
      # TODO: Tests shouldn't rely on internal state...
      @id = account_id
    end
    @files_url = "https://api.context.io/2.0/accounts/#{account_id}/files"
  end

  describe '.all' do
    before(:each) do
      json_files = File.read(File.join(@fixtures_path, 'files.json'))
      @request = stub_request(:get, @files_url).to_return(:body => json_files)
    end

    it 'returns an array of File objects' do
      ContextIO::File.all(@account).first.should be_a(ContextIO::File)
    end

    it 'calls the API request' do
      ContextIO::File.all(@account)

      @request.should have_been_requested
    end

    it 'sends a query if one is given' do
      @request.with(:query => { :email => 'me@example.com'})

      ContextIO::File.all(@account, :email => 'me@example.com')

      @request.should have_been_requested
    end

    it 'supports searching for a filename with a regexp' do
      @request.with(:query => { :file_name => '/\.pdf$/'})

      ContextIO::File.all(@account, :file_name => /\.pdf$/)

      @request.should have_been_requested
    end

    it 'converts Time objects to integer timestamps' do
      time = Time.now
      @request.with(:query => { :date_before => time.to_i.to_s })

      ContextIO::File.all(@account, :date_before => time)

      @request.should have_been_requested
    end

    context 'group_by_revisions' do
      before(:each) do
        json_files = File.read(File.join(@fixtures_path, 'files_group.json'))
        @request = stub_request(:get, @files_url).
          with(:query => { :group_by_revisions => '1' }).
          to_return(:body => json_files)
      end

      it 'converts occurences to File objects' do
        files = ContextIO::File.all(@account, :group_by_revisions => true)
        files.first[:occurences].first.should be_a(ContextIO::File)
      end

      it 'converts latest_date to a Time object' do
        files = ContextIO::File.all(@account, :group_by_revisions => true)
        files.first[:latest_date].should be_a(Time)
      end
    end
  end
end
