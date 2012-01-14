require 'context-io/error'

module ContextIO
  # Raised when Context.IO returns a 4xx HTTP status code
  #
  # @api public
  class Error::ClientError < ContextIO::Error
  end
end

