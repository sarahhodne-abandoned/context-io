require 'context-io/resource'

module ContextIO
  # A file found as an email attachment
  #
  # @api public
  class File < Resource
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
    #     :file => account.email_addresses.first,
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
          occurences = file['occurences'].map { |file| File.from_json(file) }
          {
            :occurences => occurences,
            :file_name => file['file_name'],
            :latest_date => Time.at(file['latest_date'].to_i)
          }
        else
          File.from_json(file)
        end
      end
    end

    # Create a File with the JSON from Context.IO.]
    #
    # @api private
    #
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request. See their documentation for possible keys.
    #
    # @return [File] A file with the given attributes.
    def self.from_json(json)
      account = new
      account.instance_eval do
      end

      account
    end
  end
end
