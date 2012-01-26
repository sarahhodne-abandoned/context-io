require 'faraday'
require 'context-io/core_ext/hash'
require 'context-io/request/oauth'
require 'context-io/response/parse_json'
require 'context-io/response/raise_client_error'
require 'context-io/response/raise_server_error'

module ContextIO
  # Methods for creating a connection to the API server.
  #
  # @api private
  # @private
  module Connection
    # Create and configure a Faraday connection
    #
    # @api private
    #
    # @param [true, false] raw Set this to true to disable JSON parsing of the
    #   response body.
    #
    # @return [Faraday::Connection] A Connection object that's correctly
    #   configured.
    def connection(raw=false)
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
        builder.use ContextIO::Request::ContextIOOAuth, ContextIO.authentication if ContextIO.authenticated?
        builder.use Faraday::Request::UrlEncoded
        builder.use ContextIO::Response::RaiseClientError
        builder.use ContextIO::Response::ParseJson unless raw
        builder.use ContextIO::Response::RaiseServerError
        builder.adapter(ContextIO.adapter)
      end
    end
    private :connection
  end
end

