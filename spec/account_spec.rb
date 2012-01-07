require 'spec_helper'

describe ContextIO::Account do
  describe '.all' do
    it 'should return an array of Account objects' do
      stub_request(:get, 'https://api.context.io/2.0/accounts').to_return(:body => '[{}]')
      accounts = ContextIO::Account.all
      accounts.first.should be_a(ContextIO::Account)
    end

    it 'should call the correct API request' do
      stub = stub_request(:get, 'https://api.context.io/2.0/accounts').to_return(:body => '[]')
      ContextIO::Account.all

      stub.should have_been_requested
    end
  end
end

