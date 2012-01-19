require 'context-io/resource'

module ContextIO
  # A message source. Create one of these for each mailbox a user has
  #
  # @api public
  class Source < ContextIO::Resource
    attr_accessor :label, :authentication_type, :port, :service_level, :username,
                  :server, :source_type, :sync_period, :use_ssl, :status
    attr_reader :account_id, :email
    
    # Public: Get all sources for given account.
    #
    # query - An optional Hash (default: {}) containing a query to filter the
    #         responses. For possible values see Context.IO API documentation.
    # Returns an Array of Source objects.
    #
    # account - Account object or ID
    def self.all(account, query = {})
      return [] if account.nil?
      
      account_id = account.is_a?(Account) ? account.id : account.to_s
      get("/2.0/accounts/#{account_id}/sources", query).map do |msg|
        Source.from_json(account_id, msg)
      end
    end

    # Find a source for given ID
    #
    # @api public
    #
    # @param [String] label The label of the source to look up.
    #
    # @example Find the source with the labe 'foobar'
    #   ContextIO::Source.find('abcdef012345', 'foobar')
    #
    # @return [Source] The source with the given label.
    def self.find(account, label)
      return nil if account.nil? or label.to_s.empty?
      account_id = account.is_a?(Account) ? account.id : account.to_s

      Source.from_json(account_id, get("/2.0/accounts/#{account_id}/sources/#{label.to_s}"))
    end

    # Create a Source instance from the JSON returned by the Context.IO server
    #
    # @api private
    #
    # @param [Hash] The parsed JSON object returned by a Context.IO API request.
    #   See their documentation for what keys are possible.
    #
    # @return [Source] A source with the given attributes.
    def self.from_json(account_id, json)
      source = new(account_id, json)
    end

    def initialize(account_id, attributes = {})
      raise ArgumentError if account_id.to_s.empty?
      
      @account_id = account_id.to_s
      @email = attributes['email']
      @label = attributes['label'] || ''
      @authentication_type = attributes['authentication_type']
      @port = attributes['port'] || 143
      @service_level = attributes['service_level']
      @username = attributes['username']
      @server = attributes['server']
      @source_type = attributes['type'] || 'IMAP'
      @sync_period = attributes['sync_period']
      @use_ssl = attributes['use_ssl'] || false
      @status = attributes['status']
      @password = attributes['password']
      @provider_token = attributes['provider_token']
      @provider_token_secret = attributes['provider_token_secret']
      @provider_consumer_key = attributes['provider_consumer_key']
    end

    # Sends the source data to Context.IO
    #
    # If the source has been sent to Context.IO before, this will update
    # allowed source attributes.
    #
    # @api public
    #
    # @raise [ArgumentError] If required arguments are missing.
    #
    # @example Create a source
    #   source = ContextIO::Source.new(@account.id, {'email' => 'me@example.com', 'server' => 'imap@example.com',
    #      'username' => "me", 'use_ssl' => true, 'port' => 143, 'type' => 'IMAP'})
    #   source.save
    #
    # @return [true, false] Whether the save succeeded or not.
    def save
      @label.to_s.empty? ? create_record : update_record
    end

    # Destroys current source object
    def destroy
      return false if @label.to_s.empty?

      response = delete("/2.0/accounts/#{@account_id}/sources/#{@label}")
      @label = '' if response['success']
      
      response['success']
    end

    # Update attributes on the Source object and then send them to Context.IO
    #
    # @api public
    #
    # @param [Hash] attributes The attributes to update. Allowed
    # attributes are status, sync period, service level, password,
    # provider token, provider token secret and provider consumer key
    #
    # @example Update the Source sync period to one day
    #   source.update_attributes('sync_period' => '1d')
    #
    # @return [true, false] Whether the update succeeded or not.
    def update_attributes(attributes = {})
      raise ArgumentError.new("Cannot set attributes on new record") if @label.to_s.empty?
      
      attributes.each do |k,v|
        if ["status", "sync_period", "service_level", "password", "provider_token", "provider_token_secret", "provider_consumer_key"].include? k
          send("#{k}=", v)
        end
      end
      update_record
    end

    private

    # Create the Source on Context.IO
    #
    # @api private
    #
    # @return [true, false] Whether the creation succeeded or not.
     def create_record
      if @email.to_s.empty? or @server.to_s.empty? or @username.to_s.empty? or @port.to_s.empty?
        raise ArgumentError.new("Mandatory arguments are not set")
      end
      
      params = {}
      params['email'] = @email.to_s
      params['server'] = @server.to_s
      params['username'] = @username.to_s
      params['use_ssl'] = @use_ssl.to_s
      params['port'] = @port.to_s
      params['type'] = @source_type.to_s

      # Optional parameters
      params['service_level'] = @service_level if @service_level
      params['sync_period'] = @sync_period if @sync_period
      params['password'] = @password if @password
      params['provider_token'] = @provider_token if @provider_token
      params['provider_token_secret'] = @provider_token_secret if @provider_token_secret
      params['provider_consumer_key'] = @provider_consumer_key if @provider_consumer_key

      response = post("/2.0/accounts/#{@account_id}/sources", params)
      response['success']
    end

    # Update existing Source on Context.IO
    #
    # Only sends the status, sync period, service level, password,
    # provider token, provider token secret and provider consumer key
    # as they are the only attributes the Context.IO API allows to be updated.
    #
    # @api private
    #
    # @return [true, false] Whether the update succeeded or not.
    def update_record
      return false if @label.to_s.empty?

      atts = {}

      atts["status"] = @status if @status
      atts["sync_period"] = @sync_period if @sync_period
      atts["service_level"] = @service_level if @service_level
      atts["password"] = @password if @password
      atts["provider_token"] = @provider_token if @provider_token
      atts["provider_token_secret"] = @provider_token_secret if @provider_token_secret
      atts["provider_consumer_key"] = @provider_consumer_key if @provider_consumer_key

      response = post("/2.0/accounts/#{@account_id}/sources/#{@label}", atts)
      response['success']
    end
  end
end
