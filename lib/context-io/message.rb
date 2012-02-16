require "context-io/resource"

module ContextIO
  class Message < Resource
    # @api public
    # @return [String] The unique ID of the message, as a hexadecimal string.
    attr_reader :message_id

    # @api public
    # @see Account#id
    # @return [String] The unique ID of the account the message belongs to.
    attr_reader :account_id

    # @api public
    # @return [String] The message's subject.
    attr_reader :subject

    # @api public
    # @return [Hash] Information about the sender. Possible keys are `:email`,
    #   `:name` and `:thumbnail`. All values are Strings.
    attr_reader :from

    # @api public
    # @return [Array<Hash>] Information about the receiver(s). Possible keys are
    #   `:email`, `:name` and `:thumbnail`. All values are Strings.
    attr_reader :to

    # @api public
    # @return [Array<Hash>] Information about people CC-ed on the email.
    #   Possible keys are `:email`, `:name` and `:thumbnail`. All values are
    #   Strings.
    attr_reader :cc

    # @api public
    # @return [Array<ContextIO::Source>] The sources the message is connected
    #   to. This will contact the Context.IO server to load the sources if they
    #   haven't been loaded already.
    def sources
      unless defined?(@sources)
        @sources = @source_labels.map do |label|
          Source.find(@account_id, label)
        end
      end

      @sources
    end

    # @api public
    # @return [Time] When the message was sent.
    attr_reader :date

    # @api public
    # @return [Array<String>] The folder(s) this message is in. Format is
    #   "<source_label>::<folder_name>".
    attr_reader :folders

    # @api public
    # @return [Array<ContextIO::File>] The files attached to this message.
    attr_reader :files

    # Get all messages for a given account
    #
    # @api public
    #
    # @param [ContextIO::Account, #to_s] account The account or account ID to
    #   look for messages in.
    # @param [Hash] query An optional query to filter responses by.
    # @option query [String, Regexp] :subject Get messages whose subject match
    #   this string or regular expression.
    # @option query [String] :email Email address of the contact for whom you
    #   want the latest messages exchanged with. By "exchanged with contact X"
    #   we mean any email received from contact X, sent to contact X or sent by
    #   anyone to both contact X and the source owner.
    # @option query [String] :to Email address of a contact messages have been
    #   sent to.
    # @option query [String] 
    #
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

    def self.find(account, message_id)
      return nil if account.nil? or message_id.nil?
      account_id = account.is_a?(Account) ? account.id : account.to_s

      Message.from_json(account_id, get("/2.0/accounts/#{account_id}/messages/#{message_id}"))
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
      message.instance_eval do
        @message_id = json_msg['message_id']
        @subject = json_msg['subject']
        @date = Time.at json_msg['date']
        @sources = json_msg['sources']
        @from = json_msg['addresses']['from']
        @to = json_msg['addresses']['to']
        @cc = json_msg['addresses']['cc']
        @folders = json_msg['folders']
        @files = json_msg['files']
      end

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
    # Allowed values are :plain and :html. Default value is :plain.
    def body(format = :plain)
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

    def read!
      flag("seen" => true)
    end

    def unread!
      flag("seen" => false)
    end

    def flagged!
      flag("flagged" => true)
    end

    def unflagged!
      flag("flagged" => false)
    end

    def answered!
      flag("answered" => true)
    end

    def unanswered!
      flag("answered" => false)
    end

    def draft!
      flag("draft" => true)
    end

    def undraft!
      flag("draft" => false)
    end

    def delete!
      flag("deleted" => true)
    end

    def undelete!
      flag("deleted" => false)
    end

    # Public: Returns array of messages of the thread a given message is in.
    def thread
      get("#{url}/thread")["messages"].map do |m|
        Message.from_json(account_id, m)
      end
    end

    def copy(folder_name, destination_source = nil)
      copy_move(folder_name, false, destination_source)
    end

    def move(folder_name, destination_source = nil)
      copy_move(folder_name, true, destination_source)
    end
      
    private
    def url
      "/2.0/accounts/#{account_id}/messages/#{message_id}"
    end

    def copy_move(folder_name, move, destination_source)
      raise ArgumentError.new("Valid values for 'move' flag are 1 and 0") unless [true, false].include? move
      destination = folder_name.to_s
      raise ArgumentError.new("Destination folder cannot be empty") if destination.empty?
      options = {:dst_folder => destination, :move => move ? 1 :0}
      options[:dst_source] = destination_source if destination_source
      post(url, options)
    end

    def flag(value = {})
      response = post("#{url}/flags", value)
      response["success"]
    end
  end
end
