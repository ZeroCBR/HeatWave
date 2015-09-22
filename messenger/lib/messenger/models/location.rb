require 'active_record'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/location.rb"
else
  require_relative '../../../../heatwave/app/models/location.rb'
end

class Location < ActiveRecord::Base; end
