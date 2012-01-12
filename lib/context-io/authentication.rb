module ContextIO
  # Internal: Methods related to authentication and configuration.
  module Authentication
    # Internal: Returns the authentication Hash given to SimpleOAuth.
    def authentication
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => nil,
        :token_secret => nil,
      }
    end

    # Internal: Returns a Boolean specifying whether authentication details
    # have been set up or not.
    def authenticated?
      authentication[:consumer_key] and authentication[:consumer_secret]
    end
  end
end
