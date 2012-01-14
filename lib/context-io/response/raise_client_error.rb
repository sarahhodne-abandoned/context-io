require 'faraday'
require 'context-io/error/bad_request'
require 'context-io/error/forbidden'
require 'context-io/error/not_found'
require 'context-io/error/unauthorized'
require 'context-io/error/payment_required'

module ContextIO
  module Response
    # Faraday middleware for raising errors on 4xx HTTP status codes
    #
    # @api private
    class RaiseClientError < Faraday::Response::Middleware
      # Raise an error if the response has a 4xx status code
      #
      # @raise [ContextIO::Error::ClientError] If the response has a 4xx status
      #   code.
      # @raise [ContextIO::Error::BadRequest] If the response has a 400 status
      #   code.
      # @raise [ContextIO::Error::Unauthorized] If the response has a 401 status
      #   code.
      # @raise [ContextIO::Error::PaymentRequired] If the response has a 402
      #   status code.
      # @raise [ContextIO::Error::Forbidden] If the response has a 403 status
      #   code.
      # @raise [ContextIO::Error::NotFound] If the response has a 404 status
      #   code.
      #
      # @return [void]
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

      # @return [String] The error message if one is defines, or an empty
      #   string.
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

