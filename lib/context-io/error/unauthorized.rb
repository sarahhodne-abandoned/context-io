require 'context-io/error/client_error'

module ContextIO
  # Public: Raised when Context.IO returns the HTTP status code 401
  class Error::Unauthorized < ContextIO::Error::ClientError
  end
end

