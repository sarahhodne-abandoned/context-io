require 'faraday'
require 'context-io/error/bad_request'
require 'context-io/error/forbidden'
require 'context-io/error/not_found'
require 'context-io/error/unauthorized'
require 'context-io/error/payment_required'

module ContextIO
  module Response
    # Internal: Faraday middleware for raising errors when the server returns
    # a 4xx HTTP status code.
    class RaiseClientError < Faraday::Response::Middleware
      # Internal: Check the status code and raise an error if there's a 4xx
      # status code.
      #
      # Raises a ContextIO::Error if the status code is a 4xx code.
      #
      # Returns nothing.
      def on_complete(env)
        case env[:status].to_i
        when 400
          raise ContextIO::Error::BadRequest.new(error_body(env[:body]), env[:response_headers])
        when 401
          raise ContextIO::Error::Unauthorized.new(error_body(env[:body]), env[:response_headers])
        when 402
          raise ContextIO::Error::PaymentRequired.new(error_body(env[:body]), env[:response_headers])
        when 403
          raise ContextIO::Error::Forbidden.new(error_body(env[:body]), env[:response_headers])
        when 404
          raise ContextIO::Error::NotFound.new(error_body(env[:body]), env[:response_headers])
        end
      end

      private

      # Internal: Return the error message if one is defined in the body.
      #
      # Returns the String error message (or an empty String).
      def error_body(body)
        if body['type'] == 'error' && body['value']
          body['value']
        else
          ''
        end
      end
    end
  end
end

