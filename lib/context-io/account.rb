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

    # Public: To be documented (format unknown).
    attr_reader :suspended

    # Internal: To be documented (format unknown).
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

    # Public: To be documented (format unknown).
    attr_reader :password_expired

    # Internal: To be documented (format unknown).
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
      account.created = Time.at(json['created'])
      account.suspended = json['suspended']
      account.email_addresses = json['email_addresses']
      account.first_name = json['first_name']
      account.last_name = json['last_name']
      account.password_expired = json['password_expired']
      account.sources = json['sources'].map do |source|
        Source.from_json(source)
      end

      account
    end
  end
end
