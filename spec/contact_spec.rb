require 'spec_helper'
require 'context-io/contact'

describe ContextIO::Contact do
  let(:account_id) { '0123456789abcdef' }

  describe '.all' do
    before(:each) do
      json_contacts = File.read(File.expand_path('../fixtures/contacts.json',
                                                 __FILE__))
      url = "https://api.context.io/2.0/accounts/#{account_id}/contacts"
      @all_request = stub_request(:get, url).
        to_return(:body => json_contacts)
    end

    it 'returns an array of Contacts' do
      contacts = ContextIO::Contact.all(account_id)

      contacts.first.should be_a(ContextIO::Contact)
    end

    it 'calls the API request' do
      ContextIO::Contact.all(account_id)
      @all_request.should have_been_requested
    end
  end

  describe '.find' do
    before(:each) do
      json_contact = File.read(File.expand_path('../fixtures/contact.json',
                                                __FILE__))
      url = "https://api.context.io/2.0/accounts/#{account_id}/contacts/john.doe@example.com"
      @one_request = stub_request(:get, url).
        to_return(:body => json_contact)
    end

    it 'returns a Contact' do
      contact = ContextIO::Contact.find(account_id, 'john.doe@example.com')

      contact.should be_a(ContextIO::Contact)
    end

    it 'calls the API request' do
      ContextIO::Contact.find(account_id, 'john.doe@example.com')
      @one_request.should have_been_requested
    end
  end
end
