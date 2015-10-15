require 'active_record'
require 'devise'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/config/initializers/devise.rb"
else
  require_relative '../../../../heatwave/config/initializers/devise.rb'
end

## Model for storing users, including admins and vulnerable individuals.
class User < ActiveRecord::Base; end

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/user.rb"
else
  require_relative '../../../../heatwave/app/models/user.rb'
end
