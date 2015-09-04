# Test database and rubocop
task :validate do
  system 'rake test'
  system 'rubocop -R'
end
