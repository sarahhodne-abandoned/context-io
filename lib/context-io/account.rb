require 'context-io/resource'

module ContextIO
  # An account. Create one of these for every user.
  #
  # This does not represent a mail account. An Account can have several mail
  # accounts attached to it as {Source}s.
  #
  # Only the {#first_name} and {#last_name} can be changed after creation.
  class Account < ContextIO::Resource
    # @api public
    # @return [String] The unique ID of the account.
    attr_reader :id

    # @api public
    # @return [String] The username assigned to the account.
    attr_reader :username

    # @api public
    # @return [Time] The account creation time.
    attr_reader :created

    # @api public
    # @return [Time, nil] The account suspension time, or nil if the account
    #   isn't suspended.
    attr_reader :suspended

    # @api public
    # @return [Array<String>] The email addresses associated with the account.
    attr_reader :email_addresses

    # @api public
    # @return [String] The first name of the account holder.
    attr_accessor :first_name

    # @api public
    # @return [String] The last name of the account holder.
    attr_accessor :last_name

    # @api public
    # @return [Time, nil] When the account password expired, or nil if the
    #   password hasn't expired.
    attr_reader :password_expired

    # @api public
    # @return [Array<ContextIO::Source>] The sources associated with this
    #   account.
    attr_reader :sources

    # Get all the accounts, optionally filtered with a query
    #
    # @api public
    #
    # @param [Hash] query The query to filter accounts by. All fields are
    #   optional.
    # @option query [String] :email Only return accounts associated with this
    #   email address.
    # @option query [:invalid_credentials, :connection_impossible,
    #   :no_access_to_all_mail, :ok, :temp_disabled, :disabled] :status Only
    #   return accounts with sources whose status is the one given. If an
    #   account has several sources, only those matching the given status will
    #   be included in the response.
    # @option query [true, false] :status_ok Whether to only return accounts
    #   with sources that are working or not working properly (true/false,
    #   respectively). As with the `:status` filter above, only sources matching
    #   the specific value are included in the response.
    # @option query [Integer] :limit The maximum number of results to return.
    # @option query [Integer] :offset The offset to start the list at (0 is no
    #   offset).
    #
    # @example Fetch all accounts
    #   ContextIO::Account.all
    #
    # @example Fetch all accounts with the email address me@example.com
    #   ContextIO::Account.all(:email => 'me@example.com')
    #
    # @return [Array<ContextIO::Account>] The accounts matching the query, or
    #   all if no query is given.
    def self.all(query={})
      query[:status] = query[:status].to_s.upcase if query[:status]
      if query.has_key?(:status_ok)
        query[:status_ok] = query[:status_ok] ? '1' : '0'
      end
      get('/2.0/accounts', query).map { |account| from_json(account) }
    end

    # Find an account given its ID
    #
    # @api public
    #
    # @param [String] id The ID of the account to look up.
    #
    # @example Find the account with the ID 'foobar'
    #   ContextIO::Account.find('foobar')
    #
    # @return [ContextIO::Account] The account with the given ID.
    def self.find(id)
      from_json(get("/2.0/accounts/#{id}"))
    end

    # Initialize an Account
    #
    # @api public
    #
    # @param [Hash] attributes The attributes to set on the account (all values
    #   are optional).
    # @option attributes [String] :email The primary email address of the
    #   account holder.
    # @option attributes [String] :first_name The first name of the account
    #   holder.
    # @option attributes [String] :last_name The last name of the account
    #   holder.
    #
    # @example Initialize an account with the email 'me@example.com'
    #   ContextIO::Account.new(:email => 'me@example.com')
    def initialize(attributes={})
      @email_addresses = [attributes[:email]] if attributes[:email]
      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]
    end

    # Send the account info to Context.IO
    #
    # If this is the first time the account is sent to Context.IO, the first
    # email address set will be sent as the primary email address, and the first
    # and last name will be sent if they are specified. You are required to
    # specify one email address.
    #
    # If the account has been sent to Context.IO before, this will update the
    # first and last name.
    #
    # @api public
    #
    # @raise [ArgumentError] If there isn't at least one email address specified
    #   in the {#email_addresses} field.
    #
    # @example Create an account
    #   account = ContextIO::Account.new(:email => 'me@example.com')
    #   account.save
    #
    # @return [true, false] Whether the save succeeded or not.
    def save
      id ? update_record : create_record
    end

    # Update attributes on the account object and then send them to Context.IO
    #
    # @api public
    #
    # @param [Hash] attributes The attributes to update.
    # @option attributes [String] :first_name The first name of the account
    #   holder.
    # @option attributes [String] :last_name The last name of the account
    #   holder.
    #
    # @example Update the account holder's name to "John Doe"
    #   account.update_attributes(:first_name => 'John', :last_name => 'Doe')
    #
    # @return [true, false] Whether the update succeeded or not.
    def update_attributes(attributes)
      @first_name = attributes[:first_name] if attributes[:first_name]
      @last_name = attributes[:last_name] if attributes[:last_name]

      response = put("/2.0/accounts/#{self.id}", attributes)

      response['success']
    end

    # Create the account on Context.IO
    #
    # @api private
    #
    # This will only send the first email address in the email_addresses
    # attribute (which is required) as well as the first and last name if they
    # are not-falsey.
    #
    # @return [true, false] Whether the creation succeeded or not.
    def create_record
      unless self.email_addresses && self.email_addresses.first
        raise ArgumentError.new('You must specify an email address')
      end

      attributes = { :email => self.email_addresses.first }
      attributes[:first_name] = self.first_name if self.first_name
      attributes[:last_name] = self.last_name if self.last_name

      response = post('/2.0/accounts', attributes)
      @id = response['id']

      @saved = response['success']
    end
    private :create_record

    # Update the account on Context.IO
    #
    # Only sends the first and last name, as they are the only attributes the
    # Context.IO API allows you to update.
    #
    # @api private
    #
    # @return [true, false] Whether the update succeeded or not.
    def update_record
      attributes = {}
      attributes[:first_name] = self.first_name if self.first_name
      attributes[:last_name] = self.last_name if self.last_name
      response = put("/2.0/accounts/#{self.id}", attributes)

      response['success']
    end
    private :update_record

    # Create an Account instance from the JSON returned by the Context.IO server
    #
    # @api private
    #
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for what keys are possible.
    #
    # @return [Account] An account with the given attributes.
    def self.from_json(json)
      account = new
      account.instance_eval do
        @id = json['id']
        @username = json['username']
        if json['created'] == 0
          @created = nil
        else
          @created = Time.at(json['created'])
        end
        if json['suspended'] == 0
          @suspended = nil
        else
          @suspended = Time.at(json['suspended'])
        end
        @email_addresses = json['email_addresses']
        @first_name = json['first_name']
        @last_name = json['last_name']
        if json['password_expired'] == 0
          @password_expired = nil
        else
          @password_expired = json['password_expired']
        end
        @sources = json['sources'].map do |source|
          Source.from_json(@id, source)
        end
      end

      account
    end
  end
end
