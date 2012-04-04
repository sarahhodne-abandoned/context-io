module ContextIO
  # Connect Tokens provide an easier way to add accounts through API calls
  #
  # To make creating new accounts and connecting email accounts to it with API
  # calls easier, you can simply obtain a new connect token with
  # {ConnectToken.obtain}, and then redirect the user to the provided URL. The
  # user will then be provided with a form to provide their IMAP data in, or
  # they can connect using OAuth.
  #
  # @example
  #   token = ContextIO::ConnectToken.obtain('http://example.com/callback')
  #   # redirect user to token.url
  #   # you probably need to refetch the token here
  #   account = token.account
  class ConnectToken < Resource
    # @api public
    # @return [String] The token ID
    attr_reader :token

    # @api public
    # @return [String] The email address for the attached token
    attr_reader :email

    # @api public
    # @return [Time] When the token was created
    attr_reader :created_at

    # @api public
    # @return [Time] When the token was used
    attr_reader :used_at

    # @api public
    # @return [String] The callback URL to call after the mailbox is connected
    #   to the API key.
    attr_reader :callback_url

    # @api public
    # @return [String] The service level for the account. Can be `'basic'` or
    #   `'pro'`.
    attr_reader :service_level

    # @api public
    # @return [String] The first name for the account.
    attr_reader :first_name

    # @api public
    # @return [String] The last name for the account
    attr_reader :last_name

    # @api public
    # @return [ContextIO::Account, nil] The account connected to this token
    attr_reader :account

    # Fetch all connect tokens created with your API key
    #
    # @api public
    #
    # @parm [ContextIO::Account] account Only return tokens beloning to this
    #   account (if one is passed).
    #
    # @return [Array<ContextIO::ConnectToken>] All connect tokens created with
    #   your API key.
    def self.all(account=nil)
      if account
        url = "/2.0/accounts/#{account.id}/connect_tokens"
      else
        url = '/2.0/connect_tokens'
      end

      get(url).map { |obj| from_json(obj) }
    end

    # Fetch a single connect token by it's token ID
    #
    # @api public
    #
    # @param [String] token_id The token ID. Returned by {#token}.
    # @param [ContextIO::Account] account An optional account to scope the
    #   token in (if the token isn't in this account, a not found error will be
    #   raised).
    #
    # @return [ContextIO::ConnectToken] The requested connect token.
    def self.find(token_id, account=nil)
      if account
        url = "/2.0/accounts/#{account.id}/connect_tokens/#{token_id}"
      else
        url = "/2.0/connect_tokens/#{token_id}"
      end

      from_json(get(url))
    end

    # Create a connect token
    #
    # @api public
    #
    # @param [Hash] data The data to use to create the connect token
    # @option data [String] :callback_url When the user's mailbox is connected
    #   to your API key, the browser will call this url (GET). This call will
    #   have a parameter called `contextio_token` indicating the connect_token
    #   related to this callback. You can then get this connect_token to obtain
    #   details about the account and source created through that token and save
    #   that account id in your own user data.
    # @param [ContextIO::Account] account Pass in an account if you want to add
    #   a second token instead of creating a new account.
    #
    # @return [Hash] The response data. Has two keys, `:token_id` and
    #   `:redirect_url`. You want to redirect the person to the `:redirect_url`,
    #   and you can get the token information by running
    #   `ContextIO::ConnectToken.find(response[:token_id])`.
    def self.create(data, account=nil)
      if account
        url = "/2.0/accounts/#{account.id}/connect_tokens"
      else
        url = '/2.0/connect_tokens'
      end
      response = post(url, data)

      { :token_id => response['token'], :redirect_url => response['browser_redirect_url'] }
    end

    # Delete a connect token
    #
    # @api public
    #
    # @param [String] token_id The token to destroy
    # @param [ContextIO::Account] account Scope the request to this account (if
    #   given).
    #
    # @return [Boolean] Whether the delete succeeded or not.
    def self.destroy(token_id, account=nil)
      if account
        url = "/2.0/accounts/#{account.id}/connect_tokens/#{token_id}"
      else
        url = "/2.0/connect_tokens/#{token_id}"
      end

      delete(url)['success']
    end

    # Delete the connect token
    #
    # This is just a shortcut for
    # `ContextIO::ConnectToken.destroy(token.token)`.
    #
    # @api public
    #
    # @param [ContextIO::Account] account Scope the request to this account (if
    #   given).
    #
    # @return [Boolean]Whether the delete succeeded or not
    def destroy(account=nil)
      ConnectToken.destroy(self.token, account)
    end

    # Create an ConnectToken instance from the data returned by the API
    #
    # @api private
    #
    # @param [Hash] data The parsed JSON data returned by the API.
    #
    # @return [ContextIO::ConnectToken] A connect token with the given
    #   attributes
    def self.from_json(data)
      connect_token = new
      connect_token.instance_eval do
        @token = data['token']
        @email = data['email']
        @created_at = Time.at(data['created'])
        @used_at = data['used'] == 0 ? nil : Time.at(data['used'])
        @callback_url = data['callback_url']
        @service_level = data['service_level']
        @first_name = data['first_name']
        @last_name = data['last_name']
        @account = data['account'] == [] ? nil : Account.from_json(data['account'])
      end

      connect_token
    end
  end
end
