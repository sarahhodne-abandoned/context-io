require "context-io/resource"

module ContextIO
  class Message < Resource
    attr_accessor :message_id, :account_id, :sources, :from, :to, :cc, :subject, :date, :folders, :files
    attr_reader :raw_data
    
    # Public: Get all messages for given account.
    #
    # query - An optional Hash (default: {}) containing a query to filter the
    #         responses. For possible values see Context.IO API documentation.
    # Returns an Array of Message objects.
    #
    # account - Account object or ID
    def self.all(account, query = {})
      return [] if account.nil?
      
      account_id = account.is_a?(Account) ? account.id : account.to_s
      get("/2.0/accounts/#{account_id}/messages", query).map do |msg|
        Message.from_json(account_id, msg)
      end
    end

    # Internal: Create an Message instance from the JSON returned by the
    # Context.IO server.
    #
    # json - The parsed JSON returned by the Context.IO server. See their
    #        documentation for what keys are possible.
    #
    # Returns a ContextIO::Message instance.
    def self.from_json(account_id, json_msg)
      message = new(account_id, json_msg)
      message.message_id = json_msg["message_id"]
      message.subject = json_msg["subject"]
      message.date = Time.at json_msg["date"]
      message.sources = json_msg["sources"]
      message.from = json_msg["addresses"]["from"]
      message.to = json_msg["addresses"]["to"]
      message.cc = json_msg["addresses"]["cc"]
      message.folders = json_msg["folders"]
      message.files = json_msg["files"]
      message
    end

    # Internal: Returns ContextIO::Message object
    #
    # raw_data - The parse JSON returned by the Context.IO server.
    def initialize(account_id, raw_data)
      @account_id = account_id
      @raw_data = raw_data
      @body = {}
    end

    # Public: Returns message body. Data is lazy loaded. Message
    # body fetched from Context.IO server contain plain text and html
    # format and both formats are stored.
    #
    # format - String determining required format of message body.
    # Allowed values are "plain" and "html". Default value is "plain".
    def body(format = "plain")
      if @body.empty?
        get("#{url}/body").each do |b|
          @body[b["type"]] = b["content"]
        end
      end
      @body["text/#{format}"]
    end

    # Public: Returns message headers. Data is lazy loaded.
    def headers
      @headers ||= get("#{url}/headers")
    end

    # Public: Returns message flags.
    def flags
      get("#{url}/flags")
    end

    private
    def url
      "/2.0/accounts/#{account_id}/messages/#{message_id}"
    end
  end
end
