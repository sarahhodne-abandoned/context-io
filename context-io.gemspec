Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name = 'context-io'
  s.version = '0.0.0'
  s.date = '2012-01-06'
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
  s.add_dependency('multi_json', '~> 1.0.0')
  s.add_dependency('webmock', '~> 1.7.10')

  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('rake', '~> 0.9.0')
  s.add_development_dependency('rdoc', '~> 3.10')

  # = MANIFEST =
  s.files = %w(
    LICENSE
    README.md
    Rakefile
    SPEC.md
    context-io.gemspec
    lib/context-io.rb
  )
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec\/spec_.*\.rb/ }
end

