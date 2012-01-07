require 'context-io/error/client_error'

module ContextIO
  # Public: Raised when Context.IO returns the HTTP status code 402.
  class Error::PaymentRequired < ContextIO::Error::ClientError
  end
end

