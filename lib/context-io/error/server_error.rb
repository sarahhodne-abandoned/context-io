require 'context-io/error'

module ContextIO
  # Public: Raised when Context.IO returns a 5xx HTTP status code.
  class Error::ServerError < ContextIO::Error
  end
end

