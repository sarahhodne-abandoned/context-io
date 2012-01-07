require 'faraday'
require 'multi_json'

module ContextIO
  module Response
    # Internal: Faraday middleware for parsing JSON in the response.
    class ParseJson < Faraday::Response::Middleware
      # Internal: Parse the body into JSON.
      #
      # body - The String-like body containing JSON data.
      #
      # Returns the parsed JSON data, probably an Array or a Hash.
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

