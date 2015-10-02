# Test database and rubocop
task :validate do
  system 'rake db:migrate:reset RAILS_ENV=test'
  system 'rake test'
  system 'rubocop -R'
end
