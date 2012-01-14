# encoding: utf-8

module ContextIO
  # Base class for ContextIO exceptions.
  #
  # @api public
  class Error < StandardError
    # @return [Hash{String => String}] The HTTP headers of the response.
    attr_reader :http_headers

    # Initialize a new ContextIO error
    #
    # @api private
    # @private
    #
    # @param [String] message The error message.
    # @param [Hash{String => String}] http_headers The HTTP headers.
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super(message)
    end
  end
end

