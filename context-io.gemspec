Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name = 'context-io'
  s.version = '0.0.1'
  s.date = '2012-01-26'
  s.rubyforge_project = 'context-io'

  s.summary = 'Ruby wrapper for the context.io API.'
  s.description = 'Ruby wrapper for the context.io API.'

  s.authors = ['Henrik Hodne']
  s.email = 'dvyjones@dvyjones.com'
  s.homepage = 'https://github.com/dvyjones/context-io'

  s.require_paths = %w(lib)

  s.rdoc_options = ['--charset=UTF-8', '--markup tomdoc', '--main README.md']
  s.extra_rdoc_files = %w(README.md LICENSE)

  s.add_dependency('faraday', '~> 0.7.5')
  s.add_dependency('simple_oauth', '~> 0.1.5')
  s.add_dependency('multi_json', '~> 1.0.0')

  if RUBY_PLATFORM == 'java'
    s.add_dependency('jruby-openssl', '>= 0')
  end

  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('rake', '~> 0.9.0')
  s.add_development_dependency('yard', '~> 0.7.4')
  s.add_development_dependency('yard-rspec', '~> 0.1')
  s.add_development_dependency('redcarpet', '~> 2.1.0')
  s.add_development_dependency('github-markup', '~> 0.7.0')
  s.add_development_dependency('webmock', '~> 1.7.10')

  # = MANIFEST =
  s.files = %w(
    Gemfile
    LICENSE
    README.md
    Rakefile
    SPEC.md
    context-io.gemspec
    lib/context-io.rb
    lib/context-io/account.rb
    lib/context-io/authentication.rb
    lib/context-io/config.rb
    lib/context-io/connection.rb
    lib/context-io/core_ext/hash.rb
    lib/context-io/error.rb
    lib/context-io/error/bad_request.rb
    lib/context-io/error/client_error.rb
    lib/context-io/error/forbidden.rb
    lib/context-io/error/internal_server_error.rb
    lib/context-io/error/not_found.rb
    lib/context-io/error/payment_required.rb
    lib/context-io/error/server_error.rb
    lib/context-io/error/service_unavailable.rb
    lib/context-io/error/unauthorized.rb
    lib/context-io/file.rb
    lib/context-io/folder.rb
    lib/context-io/message.rb
    lib/context-io/oauth_provider.rb
    lib/context-io/request.rb
    lib/context-io/request/oauth.rb
    lib/context-io/resource.rb
    lib/context-io/response.rb
    lib/context-io/response/parse_json.rb
    lib/context-io/response/raise_client_error.rb
    lib/context-io/response/raise_server_error.rb
    lib/context-io/source.rb
    lib/context-io/version.rb
    spec/account_spec.rb
    spec/contextio_spec.rb
    spec/file_spec.rb
    spec/fixtures/accounts.json
    spec/fixtures/files.json
    spec/fixtures/files_group.json
    spec/fixtures/folders.json
    spec/fixtures/messages.json
    spec/fixtures/oauth_providers.json
    spec/fixtures/sources.json
    spec/folder_spec.rb
    spec/message_spec.rb
    spec/oauth_provider_spec.rb
    spec/source_spec.rb
    spec/spec_helper.rb
  )
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec\/spec_.*\.rb/ }
end

