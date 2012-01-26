require 'context-io/resource'

module ContextIO
  # A file found as an email attachment
  #
  # @api public
  class File < Resource
    # @api public
    # @return [String] The ID of the file
    attr_reader :id

    # @api public
    # @return [Integer] The size of the file, in bytes.
    attr_reader :size

    # @api public
    # @return [String] The MIME type of the file.
    attr_reader :type

    # @api public
    # @return [String] The subject of the message this file was attached to
    attr_reader :subject

    # @api public
    # @return [Time] When this file was sent
    attr_reader :date

    # @api public
    # @return [Hash] Information on the different addresses attached to this
    #   file's message.
    attr_reader :addresses

    # @api public
    # @return [String] The full filename
    attr_reader :file_name

    # @api public
    # @return [Integer]
    attr_reader :body_section

    # @api public
    # @return [true, false] Whether the file supports preview
    attr_reader :supports_preview

    # @api public
    # @return [String] The (Context.IO) ID of the message this file was attached to
    attr_reader :message_id

    # @api public
    # @return [Time] When Context.IO indexed the file (not the same as when it
    #   was sent)
    attr_reader :date_indexed

    # @api public
    # @return [String] The email message ID (The Message-ID header)
    attr_reader :email_message_id

    # @api public
    # @return [Hash] Information about the people involved with the message
    attr_reader :person_info

    # @api public
    # @return [Array] The file name split up into parts
    attr_reader :file_name_structure

    # Get all files for a given account, optionally filtered with a query
    #
    # @see Account#messages
    #
    # @api public
    #
    # @param [Account, #to_s] account The account or account ID to search for
    #   files in.
    # @param [Hash] query A query to filter files by.
    # @option query [String, Regexp] :file_name The filename to search for. The
    #   string can contain shell globs ('*', '?' and '[]').
    # @option query [String] :email The email address of the contact for whom
    #   you want the latest files exchanged with. By "exchanged with contact X",
    #   we mean any email received from contact X, sent to contact X or sent by
    #   anyone to both contact X and the source owner.
    # @option query [String] :to The email address of a contact files have been
    #   sent to.
    # @option query [String] :from The email address of a contact files have
    #   been sent from.
    # @option query [String] :cc The email address of a contact CC'ed on the
    #   messages.
    # @option query [String] :bcc The email address of a contact BCC'ed on the
    #   messages.
    # @option query [#to_i] :date_before Only include files attached to messages
    #   sent before this timestamp. The value of this filter is applied to the
    #   Date header of the message, which refers to the time the message is sent
    #   from the origin.
    # @option query [#to_i] :date_after Only include files attached to messages
    #   sent after this timestamp. The value of this filter is applied to the
    #   Date header of the message, which refers to the time the message is sent
    #   from the origin.
    # @option query [#to_i] :indexed_before Only include files attached to
    #   messages indexed before this timestamp. This is not the same as the date
    #   of the email, it is the time Context.IO indexed this message.
    # @option query [#to_i] :indexed_after Only include files attached to
    #   messages indexed after this timestamp. This is not the same as the date
    #   of the email, it is the time Context.IO indexed this message.
    # @option query [true, false] :group_by_revisions (false) If this is set to
    #   true, the method will return an array of Hashes, where each Hash
    #   represents a group of revisions of the same file. The Hash has an
    #   `:occurences` field, which is an Array of {File} objects, a `:file_name`
    #   field, which is the name of the file, and a `:latest_date` field, which
    #   is a Time object representing the last time a message with this file was
    #   sent.
    # @option query [#to_i] :limit The maximum count of results to return.
    # @option query [#to_i] :offset (0) The offset to begin returning files at.
    #
    # @example Get all files for the account
    #   files = ContextIO::File.all(account)
    #
    # @example Get 10 files that we have sent
    #   files = ContextIO::File.all(account,
    #     :from => account.email_addresses.first,
    #     :limit => 10
    #   )
    #
    # @example Find PDF files
    #   files = ContextIO::File.all(account, :file_name => '*.pdf')
    #
    # @example Find JP(E)G files
    #   files = ContextIO::File.all(account, :file_name => /\.jpe?g$/)
    #
    # @return [Array<File>, Array<Hash>] The matching file objects. If the
    #   `:group_by_revisions` flag is set, the return value changes, see the
    #   documentation for that flag above.
    def self.all(account, query={})
      if query[:file_name] && query[:file_name].is_a?(Regexp)
        query[:file_name] = "/#{query[:file_name].source}/"
      end

      [:date_before, :date_after, :indexed, :indexed_after].each do |field|
        if query[field] && query[field].respond_to?(:to_i)
          query[field] = query[field].to_i
        end
      end

      if query[:group_by_revisions]
        query[:group_by_revisions] = query[:group_by_revisions] ? '1' : '0'
      end

      account_id = account.is_a?(Account) ? account.id : account.to_s
      get("/2.0/accounts/#{account_id}/files", query).map do |file|
        if query[:group_by_revisions]
          occurences = file['occurences'].map do |file|
            File.from_json(account_id, file)
          end

          {
            :occurences => occurences,
            :file_name => file['file_name'],
            :latest_date => Time.at(file['latest_date'].to_i)
          }
        else
          File.from_json(account_id, file)
        end
      end
    end

    # Fetch the content of the message.
    #
    # @api public
    #
    # @note Data transfer for this call is metered and charged at the end of the
    #   month. See [Context.IO's pricing page](http://context.io/pricing) for
    #   more info.
    #
    # @return [String] The raw contents of the file.
    def content
      get("/2.0/accounts/#@account_id/files/#@id/content", :raw => true)
    end

    # Create a File with the JSON from Context.IO.
    #
    # @api private
    #
    # @param [String] account_id The account ID.
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for possible keys.
    #
    # @return [File] A file with the given attributes.
    def self.from_json(account_id, json)
      file = new
      file.instance_eval do
        @id = json['file_id']
        @account_id = account_id
        @size = json['size']
        @type = json['type']
        @subject = json['subject']
        @date = Time.at(json['date'])
        @addresses = {}
        json['addresses'].each do |type, info|
          @addresses[type.to_sym] = {}
          if info.is_a?(Hash)
            info.each do |key, value|
              @addresses[type.to_sym][key.to_sym] = value
            end
          elsif info.is_a?(Array)
            @addresses[type.to_sym] = []
            info.each do |email_info|
              @addresses[type.to_sym] << {}
              email_info.each do |key, value|
                @addresses[type.to_sym].last[key.to_sym] = value
              end
            end
          end
        end
        @file_name = json['file_name']
        @body_section = json['body_section']
        @supports_preview = json['supports_preview']
        @message_id = json['message_id']
        @date_indexed = Time.at(json['date_indexed'])
        @email_message_id = json['email_message_id']
        @person_info = {}
        json['person_info'].each do |email, info|
          @person_info[email] = {}
          info.each do |key, value|
            @person_info[email][key.to_sym] = value
          end
        end
        @file_name_structure = []
        json['file_name_structure'].each do |part|
          @file_name_structure << [part.first, part.last.to_sym]
        end
      end

      file
    end
  end
end
