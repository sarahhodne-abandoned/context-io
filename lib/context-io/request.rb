module ContextIO
  # Internal: Defines HTTP request methods.
  module Request
    # Internal: Perform an HTTP DELETE request.
    #
    # path    - The String path for the request.
    # params  - A Hash of params to put in the query part of the URL. (default:
    #           {})
    #
    # Returns the parsed JSON body
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Internal: Perform an HTTP GET request.
    #
    # path    - The String path for the request.
    # params  - A Hash of params to put in the query part of the URL. (default:
    #           {})
    #
    # Returns the parsed JSON body.
    def get(path, params={})
      request(:get, path, params)
    end

    # Internal: Perform an HTTP POST request.
    #
    # path    - The String path for the request.
    # params  - A Hash of params to put in the body of the request. (default:
    #           {})
    #
    # Returns the parsed JSON response body.
    def post(path, params={})
      request(:post, path, params)
    end

    # Internal: Perform an HTTP PUT request.
    #
    # path    - The String path for the request
    # params  - A Hash of params to put in the body of the request. (default:
    #           {})
    #
    # Returns the parsed JSON response body.
    def put(path, params={})
      request(:put, path, params)
    end

    # Internal: Perform an HTTP request.
    #
    # method  - The HTTP method to send as a Symbol (supports :delete, :get,
    #           :put and :post).
    # path    - The String path for the request.
    # params  - A Hash of params to put in the query part of the URL (for
    #           DELETE and GET requests) or in the body of the request (for
    #           POST and PUT requests).
    #
    # Returns the parsed JSON response body.
    def request(method, path, params)
      response = connection.send(method) do |request|
        case method.to_sym
        when :delete, :get
          request.url(path, params)
        when :post, :put
          request.path = path
          request.body = params unless params.empty?
        end
      end

      response.body
    end
  end
end

