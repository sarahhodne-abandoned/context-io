require 'context-io/connection'
require 'context-io/request'

module ContextIO
  # Internal: The superclass of all classes that are a resource provided by the
  # API.
  #
  # This contains internal methods related to querying the API.
  class Resource
    include ContextIO::Connection
    include ContextIO::Request

    extend ContextIO::Connection
    extend ContextIO::Request
  end
end

