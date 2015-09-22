require 'active_record'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/rule.rb"
else
  require_relative '../../../../heatwave/app/models/rule.rb'
end

class Rule < ActiveRecord::Base; end
