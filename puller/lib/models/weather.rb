require 'active_record'

if defined?(RAILS_HOME)
  require "#{RAILS_HOME}/app/models/weather.rb"
else
  require_relative '../../../heatwave/app/models/weather.rb'
end

class Weather < ActiveRecord::Base; end
