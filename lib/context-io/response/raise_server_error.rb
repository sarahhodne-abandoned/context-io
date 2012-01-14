require 'faraday'
require 'context-io/error/internal_server_error'
require 'context-io/error/service_unavailable'

module ContextIO
  module Response
    # Faraday middleware for raising errors on 5xx status codes
    #
    # @api private
    class RaiseServerError < Faraday::Response::Middleware
      # Raise an error if the response has a 5xx status code
      #
      # @raise [ContextIO::Error::ServerError] If the response has a 5xx status
      #   code.
      # @raise [ContextIO::Error::InternalServerError] If the response has a 500
      #   status code.
      # @raise [ContextIO::Error::ServiceUnavailable] If the response has a 503
      #   status code.
      #
      # @return [void]
      def on_complete(env)
        case env[:status].to_i
        when 500
          raise ContextIO::Error::InternalServerError.new('Something is technically wrong.', env[:response_headers])
        when 503
          raise ContextIO::Error::ServiceUnavailable.new('Could not connect to mail server.', env[:response_headers])
        end
      end
    end
  end
end

