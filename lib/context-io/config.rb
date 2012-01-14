require 'context-io/version'

module ContextIO
  # Defines constants and methods related to configuration
  #
  # You shouldn't interact with this module directly, as it's included in the
  # {ContextIO} module. Mostly you'll use the {#configure} method on
  # {ContextIO}, see the example on {#configure}.
  #
  # @see #configure
  module Config
    # The HTTP connection adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # The Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}

    # The consumer key if none is set
    DEFAULT_CONSUMER_KEY = nil

    # The consumer secret if none is set
    DEFAULT_CONSUMER_SECRET = nil

    # The proxy server if none is set
    DEFAULT_PROXY = nil

    # The value of sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "context-io ruby gem #{ContextIO::VERSION}"

    # The configuration options that are settable.
    VALID_OPTIONS_KEYS = [
      :adapter,
      :connection_options,
      :consumer_key,
      :consumer_secret,
      :proxy,
      :user_agent
    ]

    # @return [Symbol] The HTTP connection adapter. Check the Faraday
    #   documentation for possible adapters.
    attr_accessor :adapter

    # @return [Hash] Connection options passed to the Faraday connection object.
    attr_accessor :connection_options

    # @return [String] The OAuth consumer key received from Context.IO.
    attr_accessor :consumer_key

    # @return [String] The OAuth consumer secret received from Context.IO.
    attr_accessor :consumer_secret

    # @return [String, URI] The URI to the HTTP proxy to use.
    attr_accessor :proxy

    # @return [String] The value to be sent in the User-Agent header. Probably
    #   doesn't need to be changed unless you're writing a big app, or another
    #   library based on this one.
    attr_accessor :user_agent

    # Makes sure the default values are always set
    #
    # @api private
    def self.extended(base)
      base.reset
    end

    # Configure with a block
    #
    # @api public
    #
    # @example Configuring OAuth
    #   ContextIO.configure do |config|
    #     config.consumer_key = 'my_consumer_key'
    #     config.consumer_secret = 'my_consumer_secret'
    #   end
    #
    # @return [self]
    def configure
      yield self
      self
    end

    # Reset the configuration to the default values
    #
    # @api public
    #
    # @example Reset the configuration
    #   ContextIO.adapter = :some_erroneous_thing
    #   ContextIO.reset
    #   ContextIO.adapter # => DEFAULT_ADAPTER
    #
    # @return [void]
    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.proxy              = DEFAULT_PROXY
      self.user_agent         = DEFAULT_USER_AGENT
    end
  end
end
