require 'faraday'
require 'simple_oauth'

module ContextIO
  # Internal: Faraday middleware for handling the OAuth header.
  class Request::ContextIOOAuth < Faraday::Middleware
    # Internal: Add the OAuth header before passing the request on to the next
    # middleware.
    #
    # env - The Rack environment.
    #
    # Returns the Rack response from the middleware or app after this.
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

    # Public: Initialize the OAuth middleware.
    #
    # app     - The Rack app or middleware to call after this one.
    # options - The Hash authentication options to be used for OAuth
    #           authentication:
    #           :consumer_key    - The String OAuth consumer key
    #           :consumer_secret - The String OAuth consumer secret
    #           :token           - Should be nil
    #           :token_secret    - Should be nil
    def initialize(app, options)
      @app, @options = app, options
    end
  end
end

