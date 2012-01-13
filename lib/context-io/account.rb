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
    # query - An optional Hash (default: {}) containing a query to filter the
    #         responses by:
    #         :email     - Only return accounts associated to this String email
    #                      address (optional).
    #         :status    - Only return accounts with sources whose status is of
    #                      a specific Symbol value. If an account has many
    #                      sources, only those matching the given value will be
    #                      included in the response. Possible statuses are:
    #                      :invalid_credentials, :connection_impossible,
    #                      :no_access_to_all_mail, :ok, :temp_disabled and
    #                      :disabled (optional).
    #         :status_ok - A Boolean value representing whether to only return
    #                      accounts with sources that are working or not
    #                      working properly (true/false, respectively). As with
    #                      the :status filter above, only sources matching the
    #                      specific value are included in the response
    #                      (optional).
    #         :limit     - The Integer maximum number of results to return
    #                      (optional).
    #         :offset    - The Integer offset to start the list at (zero-based)
    #                      (optional).
    #
    # Returns an Array of Account objects.
    def self.all(query={})
      query[:status] = query[:status].to_s.upcase if query[:status]
      if query.has_key?(:status_ok)
        query[:status_ok] = query[:status_ok] ? '1' : '0'
      end
      get('/2.0/accounts', query).map do |account|
        Account.from_json(account)
      end
    end

    # Public: Finds an account given its ID.
    #
    # id - The String ID of the account to look up.
    #
    # Returns an Account instance with the data of the account with the given
    #   ID.
    def self.find(id)
      Account.from_json(get("/2.0/accounts/#{id}"))
    end

    # Public: Initialize an Account.
    #
    # attributes - A Hash of attributes to set on the account (default value:
    #              {}):
    #              :email      - The String primary email address of the
    #                            account holder (optional).
    #              :first_name - The String first name of the account holder
    #                            (optional).
    #              :last_name  - The String last name of the account holder
    #                            (optional).
    def initialize(attributes={})
      self.email_addresses = [attributes[:email]] if attributes[:email]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
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
