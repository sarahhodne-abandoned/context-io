require 'context-io/resource'

module ContextIO
  # A message source. Create one of these for each mailbox a user has
  #
  # @api public
  class Source < ContextIO::Resource
    # Create a Source instance from the JSON returned by the Context.IO server
    #
    # @api private
    #
    # @param [Hash] The parsed JSON object returned by a Context.IO API request.
    #   See their documentation for what keys are possible.
    #
    # @return [Source] A source with the given attributes.
    def self.from_json(json)
      source = new
      # TODO: Add the necessary keys.

      source
    end
  end
end

