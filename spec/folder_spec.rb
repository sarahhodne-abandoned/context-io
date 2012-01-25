require 'spec_helper'

describe ContextIO::Folder do
  before(:each) do
    @fixtures_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
    account_id = 'abcdef1234567890'
    @account = ContextIO::Account.new
    @account.instance_eval do
      @id = account_id
    end
    source_label = 'me@example.com::imap.example.com'
    @source = ContextIO::Source.new(account_id)
    @source.instance_eval { @label = source_label }
    
    @folders_url = "https://api.context.io/2.0/accounts/#{account_id}/sources/#{source_label}/folders"
  end

  describe '.all' do
    before(:each) do
      json_folders = File.read(File.join(@fixtures_path, 'folders.json'))
      @response = stub_request(:get, @folders_url).
        to_return(:body => json_folders)
    end

    it 'retunrs array of Folder objects for given Account and Soruce objects' do
      folders = ContextIO::Folder.all(@account, @source)
      folders.should be_a(Array)
      folders.first.should be_a(ContextIO::Folder)
    end

    it 'returns array of Folder objects for given account ID and source label' do
      folders = ContextIO::Folder.all(@account.id, @source.label)
      folders.first.should be_a(ContextIO::Folder)
    end

    it 'returns empty array if no account is given' do
      ContextIO::Folder.all(nil, @source).should be_empty
    end

    it 'returns empty array if no source is given' do
      ContextIO::Folder.all(@account, nil).should be_empty
    end

    it 'calls API method' do
      ContextIO::Folder.all(@account, @source)
      @response.should have_been_requested
    end

    it 'sets the name of Folder object' do
      folder = ContextIO::Folder.all(@account, @source).first
      folder.name.should == 'Follow up'
    end
  end
end
