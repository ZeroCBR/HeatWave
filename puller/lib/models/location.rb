require 'active_record'

if defined?(RAILS_HOME)
  require "#{RAILS_HOME}/app/models/location.rb"
else
  require_relative '../../../heatwave/app/models/location.rb'
end

class Location < ActiveRecord::Base; end
