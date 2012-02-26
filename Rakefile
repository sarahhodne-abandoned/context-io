require 'bundler/gem_tasks'

task :default => :spec

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |c|
  c.rspec_opts = ['-fd', '-c']
end

require 'yard'
YARD::Rake::YardocTask.new
