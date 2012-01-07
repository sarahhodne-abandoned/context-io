require 'context-io/error'

module ContextIO
  # Public: Raised when Context.IO returns a 4xx HTTP status code
  class Error::ClientError < ContextIO::Error
  end
end

