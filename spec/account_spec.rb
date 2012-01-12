require 'spec_helper'

describe ContextIO::Account do
  describe '.all' do
    before(:each) do
      @stub = stub_request(:get, 'https://api.context.io/2.0/accounts').to_return(
        :body => '[{
          "id": "abcdef0123456789",
          "username": "me.example.com_1234567890abcdef",
          "created": 1234567890,
          "suspended": 0,
          "email_addresses": [ "me@example.com" ],
          "first_name": "John",
          "last_name": "Doe",
          "password_expired": 0,
          "sources": [{
            "server": "mail.example.com",
            "label": "me::mail.example.com",
            "username": "me",
            "port": 993,
            "authentication_type": "password",
            "use_ssl": true,
            "sync_period": "1d",
            "status": "OK",
            "service_level": "pro",
            "type": "imap"
          }]
        }]'
      )
    end

    it 'returns an array of Account objects' do
      accounts = ContextIO::Account.all
      accounts.first.should be_a(ContextIO::Account)
    end

    it 'calls the API request' do
      ContextIO::Account.all

      @stub.should have_been_requested
    end

    it 'sets the attributes on the Account objects' do
      ContextIO::Account.all.first.id.should == 'abcdef0123456789'
    end
  end
end

