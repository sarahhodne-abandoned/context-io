guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/context-io/(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
  watch('lib/context-io.rb')            { 'spec' }
  watch('spec/spec_helper.rb')          { 'spec' }
end

