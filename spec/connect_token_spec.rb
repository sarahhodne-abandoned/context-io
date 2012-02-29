require 'spec_helper'

describe ContextIO::ConnectToken do
  describe '.all' do
    before(:each) do
      json_tokens = File.read(File.expand_path('../fixtures/connect_tokens.json',
                                               __FILE__))
      url = 'https://api.context.io/2.0/connect_tokens'
      @all_request = stub_request(:get, url).
        to_return(:body => json_tokens)
    end

    it 'returns an array of ConnectToken objects' do
      tokens = ContextIO::ConnectToken.all
      tokens.first.should be_a(ContextIO::ConnectToken)
    end

    it 'calls the API request' do
      ContextIO::ConnectToken.all
      @all_request.should have_been_requested
    end
  end
end
