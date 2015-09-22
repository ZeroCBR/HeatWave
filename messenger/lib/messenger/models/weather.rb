require 'active_record'

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/weather.rb"
else
  require_relative '../../../../heatwave/app/models/weather.rb'
end

class Weather < ActiveRecord::Base; end
