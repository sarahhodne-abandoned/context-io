require 'context-io/resource'

module ContextIO
  # Public: A source. Create one of these for each mailbox a user has.
  class Source < ContextIO::Resource
    # Internal: Create a Source instance from the JSON returned by the
    # Context.IO server.
    #
    # json - A Hash containing the parsed JSON returned by the Context.IO
    #        server. See their documentation for possible keys.
    #
    # Returns a ContextIO::Source instance.
    def self.from_json(json)
      source = new
      # TODO: Add the necessary keys.

      source
    end
  end
end

