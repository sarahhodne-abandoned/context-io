require "context-io/resource"

module ContextIO
  class Folder < ContextIO::Resource
    # @api public
    # @return [String] The (Context.IO) ID of the account this folder belongs
    #   to, as a hexadecimal string.
    attr_reader :account_id

    # @api public
    # @return [String] The label of the source this folder belongs to.
    attr_reader :source_label

    # @api public
    # @return [String] The full name of the folder. This includes the name of
    #   parent folders.
    attr_reader :name

    # @api public
    # @return [String] The folder hierarchy delimiter.
    #
    # @example Get the folder name and not the entire path.
    #   folder.name.split(folder.delim).last
    attr_reader :delim

    # @api public
    # @return [Integer] The number of messages in the folder.
    attr_reader :nb_messages

    # @api public
    # @return [true, false] Whether this folder is included when Context.IO
    #   syncs with the source.
    attr_reader :included_in_sync

    # Get all folders for a given source and account
    #
    # @api public
    #
    # Returns an Array of Folder objects.
    #
    # @return [Array<ContextIO::Folder>] The folders in the given source.
    def self.all(account, source)
      return [] if account.nil? or source.nil?

      account_id = account.is_a?(Account) ? account.id : account.to_s
      source_label = source.is_a?(Source) ? source.label : source.to_s

      get("/2.0/accounts/#{account_id}/sources/#{source_label}/folders").map do |msg|
        Folder.from_json(account_id, source_label, msg)
      end
    end

    # Create a Folder with the JSON data from Context.IO
    #
    # @api private
    #
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for possible keys.
    #
    # @return [ContextIO::Folder] A Folder with the given attributes.
    def self.from_json(account_id, source_label, json)
      folder = new(account_id, source_label, json)
      folder.name = json["name"]
      folder
    end

    # Internal: Returns ContextIO::Folder object
    #
    # account_id - Id of folder's account
    # source_label - Label of folder's source
    # raw_data - The parse JSON returned by the Context.IO server.
    def initialize(account_id, source_label, raw_data)
      @account_id = account_id
      @source_label = source_label
      @raw_data = raw_data
    end
  end
end
