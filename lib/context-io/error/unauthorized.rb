require 'context-io/error/client_error'

module ContextIO
  # Raised when Context.IO returns the HTTP status code 401
  #
  # This means that the OAuth signature can't be validated.
  #
  # @api public
  class Error::Unauthorized < ContextIO::Error::ClientError
  end
end

