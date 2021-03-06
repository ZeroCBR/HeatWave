# Test database and rubocop
task :validate do
  ok = system 'rake db:migrate:reset RAILS_ENV=test'
  ok &&= system 'rake test'
  ok &&= system 'rubocop -RD'
  return false unless ok
end
