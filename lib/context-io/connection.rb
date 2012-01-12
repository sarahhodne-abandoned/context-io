require 'faraday'
require 'context-io/core_ext/hash'
require 'context-io/request/oauth'
require 'context-io/response/parse_json'
require 'context-io/response/raise_client_error'
require 'context-io/response/raise_server_error'

module ContextIO
  # Internal: Methods for creating a connection to the API server.
  module Connection
    private

    # Internal: Create a Faraday connection object that's set up with the
    # correct configuration.
    #
    # Returns a Faraday::Connection object
    def connection
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => ContextIO.user_agent,
        },
        :proxy => ContextIO.proxy,
        :ssl => { :verify => false },
        :url => 'https://api.context.io'
      }
      Faraday.new(default_options.deep_merge(ContextIO.connection_options)) do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use ContextIO::Request::ContextIOOAuth, ContextIO.authentication if ContextIO.authenticated?
        builder.use ContextIO::Response::RaiseClientError
        builder.use ContextIO::Response::ParseJson
        builder.use ContextIO::Response::RaiseServerError
        builder.adapter(ContextIO.adapter)
      end
    end
  end
end

