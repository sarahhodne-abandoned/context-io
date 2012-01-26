module ContextIO
  # Methods for sending HTTP requests
  #
  # @api private
  module Request
    # Perform an HTTP DELETE request
    #
    # @param [String] path The path to request.
    # @param [Hash] params Parameters to put in the query part of the URL
    #
    # @return [Hash, Array, Object] The parsed JSON response.
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    #
    # @param [String] path The path to request.
    # @param [Hash] params The parameters to put in the query part of the URL.
    #
    # @return [Hash, Array, Object] The parsed JSON response.
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    #
    # @param [String] path The path to request.
    # @param [Hash] params The parameters to put in the body of the request.
    #
    # @return [Hash, Array, Object] The parsed JSON response.
    def post(path, params={})
      request(:post, path, params)
    end

    # Perform an HTTP PUT request
    #
    # @param [String] path The path to request.
    # @param [Hash] The parameters to put in the body of the request.
    #
    # @return [Hash, Array, Object] The parsed JSON response.
    def put(path, params={})
      request(:put, path, params)
    end

    # Perform an HTTP request
    #
    # @param [:delete, :get, :put, :post] method The HTTP method to send.
    # @param [String] path The path to request.
    # @param [Hash] The parameters to put in the query part of the URL (for
    #   DELETE and GET requests) or in the body of the request (for POST and PUT
    #   requests).
    #
    # @return [Hash, Array, Object] The parsed JSON response.
    def request(method, path, params)
      response = connection(params.delete(:raw)).send(method) do |request|
        case method.to_sym
        when :delete, :get, :put
          request.url(path, params)
        when :post
          request.path = path
          request.body = params unless params.empty?
        end
      end

      response.body
    end
  end
end

