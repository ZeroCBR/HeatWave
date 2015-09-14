require 'active_record'

if defined?(Puller::Database::RAILS_HOME)
  require "#{Puller::Database::RAILS_HOME}/app/models/weather.rb"
else
  require_relative '../../../../heatwave/app/models/weather.rb'
end

class Weather < ActiveRecord::Base; end
