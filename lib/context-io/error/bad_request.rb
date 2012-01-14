require 'context-io/error/client_error'

module ContextIO
  # Raised when Context.IO returns the HTTP status code 400
  #
  # This usually means that some required info is missing.
  #
  # @api public
  class Error::BadRequest < ContextIO::Error::ClientError
  end
end

