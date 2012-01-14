require 'faraday'
require 'simple_oauth'

module ContextIO
  module Request
    # Faraday middleware for handling the OAuth header
    #
    # @api private
    class ContextIOOAuth < Faraday::Middleware
      # Add the OAuth header
      #
      # @param [Hash] env The Rack environment
      #
      # @return [Array] The Rack response
      def call(env)
        params = env[:body] || {}
        signature_params = params
        params.each do |key, value|
          signature_params = {} if value.respond_to?(:content_type)
        end
        header = SimpleOAuth::Header.new(env[:method], env[:url], signature_params, @options)
        env[:request_headers]['Authorization'] = header.to_s

        @app.call(env)
      end

      # Initialize the OAuth middleware
      #
      # @param [#call] The next Rack middleware of app to call.
      # @param [Hash] options The authentication options to use for OAuth
      #   authentication.
      # @option options [String] :consumer_key The OAuth consumer key
      # @option options [String] :consumer_secret The OAuth consumer secret
      # @option options [nil] :token The OAuth token, should be nil since
      #   Context.IO doesn't support three-legged authentication.
      # @option options [nil] :token_secret The Oauth token secret, should be
      #   nil since Context.IO doesn't support three-legged authentication.
      def initialize(app, options)
        @app, @options = app, options
      end
    end
  end
end

