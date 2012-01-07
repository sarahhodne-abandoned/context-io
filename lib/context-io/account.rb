require 'context-io/resource'

module ContextIO
  # Public: An account. Create one of these for every user.
  #
  # This does not represent a mail account. An Account can have several mail
  # accounts attached to it.
  class Account < ContextIO::Resource
    # Public: Get all accounts.
    #
    # Returns an Array of Account objects.
    def self.all
      get('/2.0/accounts').map do |account|
        Account.from_json(account)
      end
    end

    # Internal: Create an Account instance from the JSON returned by the
    # Context.IO server.
    #
    # json - The parsed JSON returned by the Context.IO server. See their
    #        documentation for what keys are possible.
    #
    # Returns a ContextIO::Account instance.
    def self.from_json(json)
      account = new
    end
  end
end
