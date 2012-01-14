require 'context-io/error/client_error'

module ContextIO
  # Raised when Context.IO returns the HTTP status code 404
  #
  # This means that the resource you tried to get doesn't exist.
  #
  # @api public
  class Error::NotFound < ContextIO::Error::ClientError
  end
end

