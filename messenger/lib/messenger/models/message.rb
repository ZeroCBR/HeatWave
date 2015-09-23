require 'active_record'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/message.rb"
else
  require_relative '../../../../heatwave/app/models/message.rb'
end

class Message < ActiveRecord::Base; end
