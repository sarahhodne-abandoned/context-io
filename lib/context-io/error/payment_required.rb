require 'context-io/error/client_error'

module ContextIO
  # Raised when Context.IO returns the HTTP status code 402
  #
  # This means that you're trying to do something that your plan isn't allowed
  # to do (anymore), so you need to log in and upgrade your plan.
  #
  # @api public
  class Error::PaymentRequired < ContextIO::Error::ClientError
  end
end

