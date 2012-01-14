require 'context-io/error/server_error'

module ContextIO
  # Raised when Context.IO returns the HTTP status code 503
  #
  # The 503 status code means a request required a connection to the mail
  # server, but that connection failed.
  #
  # @api public
  class Error::ServiceUnavailable < ContextIO::Error::ServerError
  end
end

