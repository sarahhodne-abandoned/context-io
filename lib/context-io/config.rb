require 'context-io/version'

module ContextIO
  # Public: Defines constants and methods related to configuration
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

    # By default, don't set a user oauth token
    DEFAULT_OAUTH_TOKEN = nil

    # By default, don't set a user oauth secret
    DEFAULT_OAUTH_TOKEN_SECRET = nil

    VALID_OPTIONS_KEYS = [
      :adapter,
      :connection_options,
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :proxy,
      :user_agent
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
      self
    end

    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.proxy              = DEFAULT_PROXY
      self.user_agent         = DEFAULT_USER_AGENT
    end
  end
end
