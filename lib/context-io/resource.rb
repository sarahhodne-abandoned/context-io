require 'context-io/connection'
require 'context-io/request'

module ContextIO
  # The superclass of all resources provided by the API
  #
  # @api private
  class Resource
    include ContextIO::Connection
    include ContextIO::Request

    extend ContextIO::Connection
    extend ContextIO::Request
  end
end

