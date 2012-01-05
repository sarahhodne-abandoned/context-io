Gem::Specification.new do |s|
  s.specificaton_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name = 'NAME'
  s.version = '0.0'
  s.date = '2012-01-01'
  s.rubyforge_project = 'NAME'

  s.summary = 'Ruby wrapper for the context.io API.'
  s.description = 'Ruby wrapper for the context.io API.'

  s.authors = ['Henrik Hodne']
  s.email = 'dvyjones@dvyjones.com'
  s.homepage = 'https://github.com/dvyjones/context-io'

  s.require_paths = %w(lib)

  s.rdoc_options = ['--charset=UTF-8', '--markup tomdoc']
  s.extra_rdoc_files = %w(README.md LICENSE)

  # = MANIFEST =
  s.files = %w()
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec\/spec_.*\.rb/ }
end

