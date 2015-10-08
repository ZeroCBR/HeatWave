require 'active_record'

## Model for storing users, including admins and vulnerable individuals.
class User < ActiveRecord::Base
  ## Override devise, since its features need not be used.
  def self.devise(*); end
end

if defined?(Messenger::Database::RAILS_HOME)
  require "#{Messenger::Database::RAILS_HOME}/app/models/user.rb"
else
  require_relative '../../../../heatwave/app/models/user.rb'
end
