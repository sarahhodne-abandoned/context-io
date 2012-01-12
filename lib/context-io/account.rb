require 'context-io/resource'

module ContextIO
  # Public: An account. Create one of these for every user.
  #
  # This does not represent a mail account. An Account can have several mail
  # accounts attached to it.
  class Account < ContextIO::Resource
    # Public: Returns the unique String ID of the account.
    attr_reader :id

    # Internal: Sets the unique String ID of the account.
    attr_writer :id

    # Public: Returns the String username of the account.
    attr_reader :username

    # Internal: Sets the String username of the account.
    attr_writer :username

    # Public: Returns the Time the account was created.
    attr_reader :created

    # Internal: Sets the Time the account was created.
    attr_writer :created

    # Public: Returns the Time the account was suspended, or nil if the account
    # isn't suspended.
    attr_reader :suspended

    # Internal: Sets the Time the account was suspended, or nil if the account
    # isn't suspended.
    attr_writer :suspended

    # Public: Returns the Array of String email addresses associated with the
    # account.
    attr_reader :email_addresses

    # Internal: Sets the Array of String email addresses associated with the
    # account.
    attr_writer :email_addresses

    # Public: Returns the String first name of the account holder.
    attr_reader :first_name

    # Public: Sets the String first name of the account holder.
    attr_writer :first_name

    # Public: Returns the String last name of the account holder.
    attr_reader :last_name

    # Public: Sets the String last name of the account holder.
    attr_writer :last_name

    # Public: Returns the Time the password for the account expired, or nil if
    # the password hasn't expired.
    attr_reader :password_expired

    # Internal: Sets the Time the password for the account expired, or nil if
    # the password hasn't expired.
    attr_writer :password_expired

    # Public: Returns an Array of Source objects associated with the account.
    attr_reader :sources

    # Internal: Sets the Array of Source objects associated with the account.
    attr_writer :sources

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
      account.id = json['id']
      account.username = json['username']
      if json['created'] == 0
        account.created = nil
      else
        account.created = Time.at(json['created'])
      end
      if json['suspended'] == 0
        account.suspended = nil
      else
        account.suspended = Time.at(json['suspended'])
      end
      account.email_addresses = json['email_addresses']
      account.first_name = json['first_name']
      account.last_name = json['last_name']
      if json['password_expired'] == 0
        account.password_expired = nil
      else
        account.password_expired = json['password_expired']
      end
      account.sources = json['sources'].map do |source|
        Source.from_json(source)
      end

      account
    end
  end
end
