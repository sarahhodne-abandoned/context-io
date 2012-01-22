require "context-io/resource"

module ContextIO
  class Folder < ContextIO::Resource
    attr_accessor :account_id, :source_label, :name
    attr_reader :raw_data
    
    # Public: Get all folders for given source.
    #
    # Returns an Array of Folder objects.
    #
    # account - Account object or ID
    # source - Source object or source label
    def self.all(account, source)
      return [] if account.nil? or source.nil?
      
      account_id = account.is_a?(Account) ? account.id : account.to_s
      source_label = source.is_a?(Source) ? source.label : source.to_s
      
      get("/2.0/accounts/#{account_id}/sources/#{source_label}/folders").map do |msg|
        Folder.from_json(account_id, source_label, msg)
      end
    end

    # Internal: Create a Folders instance from the JSON returned by the
    # Context.IO server.
    #
    # json - The parsed JSON returned by the Context.IO server.
    #
    # Returns a ContextIO::Folder instance.
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

    # Public: Creates new folder within given folder
    #
    # subdir_name - Name of folder to be created
    #
    # Returns true if folder is created; false otherwise
    def mkdir(subdir_name)
      base_url = "/2.0/accounts/#{account_id}/sources"
      escaped = "#{source_label}/folders/#{name}/#{subdir_name}".split('/').map do |part|
        URI.escape(part, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end.join('/')
      response = put("/2.0/accounts/#{account_id}/sources/#{escaped}")
      response["success"]
    end
  end
end
