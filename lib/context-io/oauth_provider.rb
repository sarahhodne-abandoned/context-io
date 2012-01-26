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

