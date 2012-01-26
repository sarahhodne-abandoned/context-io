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

  describe '.create' do
    before(:each) do
      @request = stub_request(:post, 'https://api.context.io/2.0/oauth_providers').
        to_return(:body => '{
          "success": true,
          "provider_consumer_key": "a",
          "resource_url": "https://api.context.io/2.0/oauth_providers/a"
        }')
    end

    it 'returns true for a successful creation' do
      ContextIO::OAuthProvider.create(:gmail, 'a', 'b').should be_true
    end

    it 'calls the API request' do
      ContextIO::OAuthProvider.create(:gmail, 'a', 'b')

      @request.should have_been_requested
    end
  end

  describe '.find' do
    before(:each) do
      json_providers = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'oauth_providers.json'))
      @provider = MultiJson.decode(json_providers).first
      @key = @provider['provider_consumer_key']
      @request = stub_request(:get, "https://api.context.io/2.0/oauth_providers/#@key").
        to_return(:body => MultiJson.encode(@provider))
    end

    it 'calls the API request' do
      ContextIO::OAuthProvider.find(@key)

      @request.should have_been_requested
    end

    it 'returns an instance of OAuthProvider' do
      ContextIO::OAuthProvider.find(@key).should be_a(ContextIO::OAuthProvider)
    end
  end

  describe '#destroy' do
    before(:each) do
      json_providers = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'oauth_providers.json'))
      provider = MultiJson.decode(json_providers).first
      @key = provider['provider_consumer_key']
      @provider = ContextIO::OAuthProvider.from_json(provider)
      @request = stub_request(:delete, "https://api.context.io/2.0/oauth_providers/#@key").
        to_return(:body => '{"success":true}')
    end

    it 'calls the API request' do
      @provider.destroy

      @request.should have_been_requested
    end

    it 'returns true for a successful destroy' do
      @provider.destroy.should be_true
    end
  end
end
