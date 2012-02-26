module ContextIO
  class Discovery < Resource
    # Discover IMAP settings for a given email address
    #
    # This is useful when you want to add an email account under your API key
    # (see {ContextIO::Source}) and you'd like to make the settings easier to
    # fill by the user with prepopulated data.
    #
    # This will also figure out if OAuth over IMAP is available.
    #
    # @api public
    #
    # @param [Symbol] source_type The type of source you want to discover
    #   settings for. Right now, the only supported source type is `:imap`.
    # @param [String] email An email address you want to discover IMAP settings
    #   for. Make sure `source_type` is set to `:imap`.
    #
    # @return [ContextIO::Discovery, nil] If likely IMAP account settings have
    #   been found for the given address, it will return those in the form of a
    #   {ContextIO::Discovery} object. Otherwise, it'll return `nil`.
    def self.discover(source_type, email)
      query = { 'source_type' => source_type.to_s.upcase, 'email' => email }
      response = get('/2.0/discovery', query)

      if response['found']
        from_json(response)
      else
        nil
      end
    end

    # Create a Discovery instance with the JSON from Context.IO
    #
    # @api private
    #
    # @param [Hash] json The parsed JSON object returned by a Context.IO API
    #   request (probably /2.0/discovery).
    #
    # @return [ContextIO::Discovery]
    def self.from_json(json)
      discovery = new
      discovery.instance_eval do
        @email = json['email']
        @type = json['type']
        @server = json['imap']['server']
        @username = json['imap']['username']
        @port = json['imap']['port']
        @use_ssl = json['imap']['use_ssl']
        @oauth = json['imap']['oauth']
        @documentation = json['documentation'].inject(&:symbolize_keys)
      end

      discovery
    end
  end
end
