# encoding: utf-8

module ContextIO
  # Methods related to authentication and configuration.
  #
  # @api private
  module Authentication
    # @return [Hash] The authentication details for OAuth.
    def authentication
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => nil,
        :token_secret => nil,
      }
    end

    # @return [Boolean] Whether authentication details are configured or not.
    def authenticated?
      authentication[:consumer_key] and authentication[:consumer_secret]
    end
  end
end
