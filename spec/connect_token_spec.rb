require 'spec_helper'

describe ContextIO::ConnectToken do
  describe '.all' do
    context 'without passing in an account' do
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

    context 'with passing in an account' do
      before(:each) do
        json_tokens = File.read(File.expand_path('../fixtures/connect_tokens.json',
                                                 __FILE__))
        @account = ContextIO::Account.new
        @account.instance_eval { @id = '0123456789abcdef' }

        url = "https://api.context.io/2.0/accounts/#{@account.id}/connect_tokens"
        @all_request = stub_request(:get, url).
          to_return(:body => json_tokens)
      end

      it 'returns an array of ConnectToken objects' do
        tokens = ContextIO::ConnectToken.all(@account)
        tokens.first.should be_a(ContextIO::ConnectToken)
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.all(@account)
        @all_request.should have_been_requested
      end
    end
  end

  describe '.find' do
    context 'without passing in an account' do
      before(:each) do
        json_token = File.read(File.expand_path('../fixtures/connect_token.json',
                                                 __FILE__))
        url = 'https://api.context.io/2.0/connect_tokens/1234567890abcdef'
        @single_request = stub_request(:get, url).
          to_return(:body => json_token)
      end

      it 'returns a ConnectToken object' do
        token = ContextIO::ConnectToken.find('1234567890abcdef')
        token.should be_a(ContextIO::ConnectToken)
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.find('1234567890abcdef')
        @single_request.should have_been_requested
      end
    end

    context 'with passing in an account' do
      before(:each) do
        json_token = File.read(File.expand_path('../fixtures/connect_token.json',
                                                 __FILE__))
        @account = ContextIO::Account.new
        @account.instance_eval { @id = '0123456789abcdef' }

        url = "https://api.context.io/2.0/accounts/#{@account.id}/connect_tokens/1234567890abcdef"
        @single_request = stub_request(:get, url).
          to_return(:body => json_token)
      end

      it 'returns a ConnectToken object' do
        token = ContextIO::ConnectToken.find('1234567890abcdef', @account)
        token.should be_a(ContextIO::ConnectToken)
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.find('1234567890abcdef', @account)
        @single_request.should have_been_requested
      end
    end
  end

  describe '.create' do
    context 'without passing an account' do
      before(:each) do
        json_response = File.read(File.expand_path('../fixtures/create_connect_token.json', __FILE__))

        url = 'https://api.context.io/2.0/connect_tokens'
        @create_request = stub_request(:post, url).
          to_return(:body => json_response)
      end

      it 'returns a token ID' do
        response = ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' })
        response[:token_id].should == 'abcdef0123456789'
      end

      it 'returns the URL to redirect to' do
        response = ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' })
        response[:redirect_url].should_not be_empty
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' })
        @create_request.should have_been_requested
      end
    end

    context 'with passing an account' do
      before(:each) do
        json_response = File.read(File.expand_path('../fixtures/create_connect_token.json', __FILE__))
        @account = ContextIO::Account.new
        @account.instance_eval { @id = '0123456789abcdef' }

        url = "https://api.context.io/2.0/accounts/#{@account.id}/connect_tokens"
        @create_request = stub_request(:post, url).
          to_return(:body => json_response)
      end

      it 'returns a token ID' do
        response = ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' }, @account)
        response[:token_id].should == 'abcdef0123456789'
      end

      it 'returns the URL to redirect to' do
        response = ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' }, @account)
        response[:redirect_url].should_not be_empty
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.create({ :callback_url => 'http://example.com' }, @account)
        @create_request.should have_been_requested
      end
    end
  end

  describe '.destroy' do
    context 'without passing an account' do
      before(:each) do
        url = 'https://api.context.io/2.0/connect_tokens/1234567890abcdef'
        @destroy_request = stub_request(:delete, url).
          to_return(:body => '{"success":true}')
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.destroy('1234567890abcdef')
        @destroy_request.should have_been_requested
      end

      it 'returns the success attribute' do
        ContextIO::ConnectToken.destroy('1234567890abcdef').should be_true
      end
    end

    context 'with passing an account' do
      before(:each) do
        @account = ContextIO::Account.new
        @account.instance_eval { @id = '0123456789abcdef' }
        url = "https://api.context.io/2.0/accounts/#{@account.id}/connect_tokens/1234567890abcdef"
        @destroy_request = stub_request(:delete, url).
          to_return(:body => '{"success":true}')
      end

      it 'calls the API request' do
        ContextIO::ConnectToken.destroy('1234567890abcdef', @account)
        @destroy_request.should have_been_requested
      end

      it 'returns the success attribute' do
        ContextIO::ConnectToken.destroy('1234567890abcdef', @account).should be_true
      end
    end
  end

  describe '#destroy' do
    context 'without passing an account' do
      before(:each) do
        url = 'https://api.context.io/2.0/connect_tokens/1234567890abcdef'
        @destroy_request = stub_request(:delete, url).
          to_return(:body => '{"success":true}')
        @token = ContextIO::ConnectToken.new
        @token.instance_eval do
          @token = '1234567890abcdef'
        end
      end

      it 'calls the API request' do
        @token.destroy
        @destroy_request.should have_been_requested
      end

      it 'returns the success attribute' do
        @token.destroy.should be_true
      end
    end

    context 'with passing an account' do
      before(:each) do
        @account = ContextIO::Account.new
        @account.instance_eval { @id = '0123456789abcdef' }
        url = "https://api.context.io/2.0/accounts/#{@account.id}/connect_tokens/1234567890abcdef"
        @destroy_request = stub_request(:delete, url).
          to_return(:body => '{"success":true}')
        @token = ContextIO::ConnectToken.new
        @token.instance_eval do
          @token = '1234567890abcdef'
        end
      end

      it 'calls the API request' do
        @token.destroy(@account)
        @destroy_request.should have_been_requested
      end

      it 'returns the success attribute' do
        @token.destroy(@account).should be_true
      end
    end
  end
end
