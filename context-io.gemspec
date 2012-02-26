# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'context-io/version'

Gem::Specification.new do |s|
  s.name = 'context-io'
  s.version = ContextIO::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')

  s.summary = 'Ruby wrapper for the context.io API.'
  s.description = 'Ruby wrapper for the context.io API.'

  s.author = 'Henrik Hodne'
  s.email = 'dvyjones@dvyjones.com'
  s.homepage = 'https://github.com/dvyjones/context-io'

  s.require_paths = %w(lib)

  s.add_runtime_dependency('faraday', '~> 0.7.5')
  s.add_runtime_dependency('simple_oauth', '~> 0.1.5')
  s.add_runtime_dependency('multi_json', '~> 1.0.0')

  if RUBY_PLATFORM == 'java'
    s.add_runtime_dependency('jruby-openssl', '>= 0')
  end

  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('rake', '~> 0.9.0')
  s.add_development_dependency('yard', '~> 0.7.4')
  s.add_development_dependency('redcarpet', '~> 2.1.0')
  s.add_development_dependency('github-markup', '~> 0.7.0')
  s.add_development_dependency('webmock', '~> 1.7.10')

  s.files = `git ls-files`.split("\n") rescue ''
  s.test_files = `git ls-files -- spec/*`.split("\n")
end

