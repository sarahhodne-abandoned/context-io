require 'context-io/resource'

module ContextIO
  # A message source. Create one of these for each mailbox a user has
  #
  # @api public
  class Source < ContextIO::Resource
    attr_accessor :label, :authentication_type, :port, :service_level, :username,
                  :server, :type, :sync_period, :use_ssl, :status
    attr_reader :account_id, :email
    
    def self.all(account, query = {})
      return [] if account.nil?
      
      account_id = account.is_a?(Account) ? account.id : account.to_s
      get("/2.0/accounts/#{account_id}/sources", query).map do |msg|
        Source.from_json(account_id, msg)
      end
    end

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
      @label = attributes['label']
      @authentication_type = attributes['authentication_type']
      @port = attributes['port']
      @service_level = attributes['service_level']
      @username = attributes['username']
      @server = attributes['server']
      @type = attributes['type']
      @sync_period = attributes['sync_period']
      @use_ssl = attributes['use_ssl']
      @status = attributes['status']
      @password = attributes['password']
      @provider_token = attributes['provider_token']
      @provider_token_secret = attributes['provider_token_secret']
      @provider_consumer_key = attributes['provider_consumer_key']
    end
  end
end
