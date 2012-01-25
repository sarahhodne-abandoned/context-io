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
    # @overload all(account_id, source_label)
    #   @param [#to_s] account_id The account ID
    #   @param [#to_s] source_label The source label
    # @overload all(source)
    #   @param [ContextIO::Source] source The source object
    #
    # @example Find a the folders on a given source.
    #   ContextIO::Folder.all(source)
    #
    # @return [Array<ContextIO::Folder>] The folders in the given source.
    def self.all(*args)
      if args.length == 1
        account_id = args.first.account_id
        source_label = args.first.label
      elsif args.length == 2
        account_id = args.first.to_s
        source_label = args.last.to_s
      else
        raise ArgumentError, "Expecting one or two arguments, got #{args.length}"
      end

      get("/2.0/accounts/#{account_id}/sources/#{source_label}/folders").map do |msg|
        Folder.from_json(account_id, source_label, msg)
      end
    end

    # Create a Folder with the JSON data from Context.IO
    #
    # @api private
    #
    # @param [String] account_id The account ID the source belongs to.
    # @param [String] source_label The label of the source this folder belongs
    #   to.
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for possible keys.
    #
    # @return [ContextIO::Folder] A Folder with the given attributes.
    def self.from_json(account_id, source_label, json)
      folder = new
      folder.instance_eval do
        @account_id = account_id
        @source_label = source_label
        @name = json['name']
        @delim = json['delim']
        @nb_messages = json['nb_messages']
        @included_in_sync = json['included_in_sync']
      end

      folder
    end
  end
end
