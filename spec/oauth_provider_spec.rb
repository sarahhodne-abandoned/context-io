require 'spec_helper'

describe ContextIO::OAuthProvider do
  describe '.all' do
    before(:each) do
      json_providers = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'oauth_providers.json'))
      @request = stub_request(:get, 'https://api.context.io/2.0/oauth_providers').
        to_return(:body => json_providers)
    end

    it 'returns an array of OAuthProvider objects' do
      providers = ContextIO::OAuthProvider.all
      providers.first.should be_a(ContextIO::OAuthProvider)
    end

    it 'calls the API request' do
      ContextIO::OAuthProvider.all

      @request.should have_been_requested
    end

    it 'sets the attributes on the provider objects' do
      ContextIO::OAuthProvider.all.first.consumer_key.should == '1qa2ws3ed'
    end
  end
end
