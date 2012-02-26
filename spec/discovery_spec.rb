require 'spec_helper'

describe ContextIO::Discovery do
  before(:each) do
    fixtures_path = File.join(File.dirname(__FILE__), 'fixtures')
    json_discovery = File.read(File.join(fixtures_path, 'discovery.json'))
    uri = 'https://api.context.io/2.0/discovery'
    @existing_request = stub_request(:get, uri)
      .with(:query => { :email => 'example@gmail.com', :source_type => 'IMAP'})
      .to_return(:body => json_discovery)

    @nosettings_request = stub_request(:get, uri)
      .with(:query => { :email => 'me@example.com', :source_type => 'IMAP'})
      .to_return(:body => '{"email":"me@example.com","found":false}')
  end

  describe '.discover' do
    it 'returns a Discovery instance' do
      discovery = ContextIO::Discovery.discover(:imap, 'example@gmail.com')
      discovery.should be_a(ContextIO::Discovery)
    end

    it 'returns nil if no settings are found' do
      discovery = ContextIO::Discovery.discover(:imap, 'me@example.com')
      discovery.should be_nil
    end

    it 'calls the API resource' do
      ContextIO::Discovery.discover(:imap, 'example@gmail.com')
      @existing_request.should have_been_requested
    end
  end
end
