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

    it 'accepts a Source object as an argument' do
      expect { ContextIO::Folder.all(@source) }.to_not raise_error
    end

    it 'accepts an account ID and a source label as arguments' do
      expect { ContextIO::Folder.all(@account.id, @source.label) }.to_not raise_error
    end

    it 'returns an array of Folder objects' do
      folders = ContextIO::Folder.all(@source)
      folders.first.should be_a(ContextIO::Folder)
    end

    it 'calls the API method' do
      ContextIO::Folder.all(@source)
      @response.should have_been_requested
    end

    it 'sets the name of Folder object' do
      folder = ContextIO::Folder.all(@source).first
      folder.name.should == 'Follow up'
    end
  end
end
