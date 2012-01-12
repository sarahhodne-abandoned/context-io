module ContextIO
  # @private
  module Authentication
    # Authentication hash
    #
    # @return [Hash]
    def authentication
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => nil,
        :token_secret => nil,
      }
    end

    # Check whether user is authenticated
    #
    # @return [Boolean]
    def authenticated?
      authentication[:consumer_key] and authentication[:consumer_secret]
    end
  end
end
