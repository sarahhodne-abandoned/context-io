require 'context-io/error'

module ContextIO
  # Raised when Context.IO returns a 5xx HTTP status code.
  #
  # @api public
  class Error::ServerError < ContextIO::Error
  end
end

