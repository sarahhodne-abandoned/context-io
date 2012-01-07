require 'context-io/error/client_error'

module ContextIO
  # Public: Raised when ContextIO returns the HTTP status code 403
  class Error::Forbidden < ContextIO::Error::ClientError
  end
end

