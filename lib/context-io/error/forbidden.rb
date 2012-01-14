require 'context-io/error/client_error'

module ContextIO
  # Raised when ContextIO returns the HTTP status code 403
  #
  # This usually means that the resource isn't accessible.
  #
  # @api public
  class Error::Forbidden < ContextIO::Error::ClientError
  end
end

