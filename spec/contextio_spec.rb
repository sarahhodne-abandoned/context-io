require 'spec_helper'

describe ContextIO do
  after do
    ContextIO.reset
  end

  describe '.adapter' do
    it 'should return the default adapter' do
      ContextIO.adapter.should == ContextIO::Config::DEFAULT_ADAPTER
    end
  end

  describe '.adapter=' do
    it 'should set the adapter' do
      ContextIO.adapter = :typhoeus
      ContextIO.adapter.should == :typhoeus
    end
  end

  describe '.user_agent' do
    it 'should return the default user agent' do
      ContextIO.user_agent.should == ContextIO::Config::DEFAULT_USER_AGENT
    end
  end

  describe '.user_agent=' do
    it 'should set the user agent' do
      ContextIO.user_agent = 'Custom User Agent'
      ContextIO.user_agent.should == 'Custom User Agent'
    end
  end

  describe '.configure' do
    ContextIO::Config::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        ContextIO.configure do |config|
          config.send("#{key}=", key)
          ContextIO.send(key).should == key
        end
      end
    end
  end
end

