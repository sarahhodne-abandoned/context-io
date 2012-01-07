require 'faraday'
require 'context-io/error/internal_server_error'
require 'context-io/error/service_unavailable'

module ContextIO
  module Response
    # Internal: Faraday middleware that raises errors when server returns
    # 5xx status codes.
    class RaiseServerError < Faraday::Response::Middleware
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

