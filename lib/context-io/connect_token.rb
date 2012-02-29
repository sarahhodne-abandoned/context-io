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
    # Fetch all connect tokens created with your API key
    def self.all
      get('/2.0/connect_tokens').map { |obj| from_json(obj) }
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
        @used = data['used'] == 1
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
