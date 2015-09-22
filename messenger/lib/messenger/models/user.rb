require 'active_record'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/user.rb"
else
  require_relative '../../../../heatwave/app/models/user.rb'
end

class User < ActiveRecord::Base; end
