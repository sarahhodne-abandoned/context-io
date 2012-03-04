module ContextIO
  class Contact < Resource
    # @api public
    # @return [String] The email address of the contact.
    attr_reader :email

    # @api public
    # @return [Integer] The number of messages exchanged with this contact.
    attr_reader :count

    # @api public
    # @return [String] The name associated to the contact.
    attr_reader :name

    # @api public
    # @return [String] A URL pointing to a Gravatar image associated to the
    #   contact's email address, if applicable.
    attr_reader :thumbnail

    # Retrieve all contacts for a given account
    #
    # @api public
    #
    # @param [ContextIO::Account, #to_s] account The account to look for
    #   contacts in.
    # @param [Hash] query An optional query to use for filtering the contacts.
    # @option query [String] :search A string identifying the name or the email
    #   address of the contact(s) you are looking for.
    # @option query [Time] :active_before Only include contacts included in at
    #   least one email dated before a given time.
    # @option query [Time] :active_after Only include contacts included in at
    #   least one email dated after a given time.
    # @option query [Integer] :limit The maximum number of results to return.
    # @option query [Integer] :offset Start the list at this offset.
    #
    # @return [Array<ContextIO::Contact>] The matching contacts.
    def self.all(account, query={})
      account_id = account.is_a?(Account) ? account.id : account.to_s
      get("/2.0/accounts/#{account_id}/contacts")['matches'].map do |data|
        from_json(account_id, data)
      end
    end

    # Retrieve a single contact.
    #
    # @api public
    #
    # @param [ContextIO::Account, #to_s] account The account or account ID to
    #   look for contacts in.
    # @param [#to_s] email The email address of the contact to look for.
    #
    # @return [ContextIO::Contact] The matching contact
    def self.find(account, email)
      account_id = account.is_a?(Account) ? account.id : account.to_s
      from_json(account_id, get("/2.0/accounts/#{account_id}/contacts/#{email}"))
    end

    # Create a Contact with the data returned by the API.
    #
    # @api private
    #
    # @param [String] account_id The ID for the account this contact belongs to.
    # @param [Hash] data The data returned by the API.
    #
    # @return [ContextIO::Contact] A Contact with the given attributes.
    def self.from_json(account_id, data)
      contact = new
      contact.instance_eval do
        @account_id = account_id
        @email = data['email']
        @count = data['count']
        @name = data['name']
        @thumbnail = data['thumbnail']
      end

      contact
    end
  end
end
