require 'faraday'
require 'multi_json'

module ContextIO
  module Response
    # Faraday middleware for parsing JSON in the response body
    #
    # @api private
    class ParseJson < Faraday::Response::Middleware
      # Parse the response body into JSON
      #
      # @param [#to_s] The response body, containing JSON data.
      #
      # @return [Object] The parsed JSON data, probably an Array or a Hash.
      def parse(body)
        case body
        when ''
          nil
        when 'true'
          true
        when 'false'
          false
        else
          ::MultiJson.decode(body)
        end
      end
    end
  end
end

