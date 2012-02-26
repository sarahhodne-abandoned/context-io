require 'context-io/config'
require 'context-io/authentication'
require 'context-io/account'
require 'context-io/discovery'
require 'context-io/file'
require 'context-io/oauth_provider'
require 'context-io/source'
require 'context-io/message'
require 'context-io/folder'

# The main ContextIO namespace.
module ContextIO
  extend Config
  extend Authentication
end
