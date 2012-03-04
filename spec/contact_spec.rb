require 'spec_helper'
require 'context-io/contact'

describe ContextIO::Contact do
  describe '.all' do
    let(:account_id) { '0123456789abcdef' }

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
end
