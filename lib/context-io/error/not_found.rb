require 'context-io/error/client_error'

module ContextIO
  # Public: Raised when Context.IO returns the HTTP status code 404
  class Error::NotFound < ContextIO::Error::ClientError
  end
end

