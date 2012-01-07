module ContextIO
  # Public: Custom error class for rescuing from all ContextIO errors
  class Error < StandardError
    # Public: The HTTP headers in the response.
    attr_reader :http_headers

    # Internal: Initializes a new Error object
    #
    # message      - The String message.
    # http_headers - A Hash containing all the HTTP headers.
    #
    # Returns a ContextIO::Error instance.
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super(message)
    end
  end
end

