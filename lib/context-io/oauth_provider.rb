module ContextIO
  class OAuthProvider < Resource
    # @api public
    # @return [String] The identification of the OAuth provider. This must be
    #   either "GMAIL" or "GOOGLEAPPSMARKETPLACE".
    attr_reader :type

    # @api public
    # @return [String] The OAuth consumer key.
    attr_reader :consumer_key

    # @api public
    # @return [String] The OAuth consumer secret.
    attr_reader :consumer_secret

    # Get all OAuth providers configured
    #
    # @api public
    #
    # @return [Array<ContextIO::OAuthProvider>] All OAuth providers.
    def self.all
      get('/2.0/oauth_providers').map { |provider| from_json(provider) }
    end

    # Create an OAuth provider
    #
    # @api public
    #
    # @param ['GMAIL', 'GOOGLEAPPSMARKETPLACE', :gmail, :googleappsmarketplace]
    #   type The identification of the OAuth provider.
    # @param [#to_s] consumer_key The OAuth consumer key.
    # @param [#to_s] consumer_secret The OAuth consumer secret.
    #
    # @return [true, false] Whether the create succeeded or not.
    def self.create(type, consumer_key, consumer_secret)
      post('/2.0/oauth_providers', {
        :type => type.to_s.upcase,
        :provider_consumer_key => consumer_key.to_s,
        :provider_consumer_secret => consumer_secret.to_s
      })['success']
    end

    # Retrieve an OAuth provider
    #
    # @api public
    #
    # @param [#to_s] consumer_key The OAuth consumer key.
    #
    # @return [ContextIO::OAuthProvider] The OAuth provider.
    def self.find(consumer_key)
      from_json(get("/2.0/oauth_providers/#{consumer_key}"))
    end

    # Destroy the OAuth provider
    #
    # @api public
    #
    # @return [true, false] Whether the destroy was successful or not.
    def destroy
      delete("/2.0/oauth_providers/#@consumer_key")['success']
    end

    # Create an OAuth provider with the JSON data from Context.IO.
    #
    # @api private
    #
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for possible keys.
    #
    # @return [ContextIO::OAuthProvider] An OAuth provider with the given
    #   attributes.
    def self.from_json(json)
      provider = new
      provider.instance_eval do
        @type = json['type']
        @consumer_key = json['provider_consumer_key']
        @consumer_secret = json['provider_consumer_secret']
      end

      provider
    end
  end
end

