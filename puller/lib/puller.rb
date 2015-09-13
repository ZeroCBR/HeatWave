require 'active_record'

require 'models/weather'
require 'models/location'

require 'puller/puller'
require 'puller/version'
require 'puller/getter'
require 'puller/processor'
require 'puller/model_marshaler'

RAILS_HOME = '../heatwave' unless defined?(RAILS_HOME)

DATABASE_CONFIG = {
  'development' => {
    'adapter' => 'sqlite3',
    'pool' => 5,
    'timeout' => 5000,
    'database' => "#{RAILS_HOME}/db/development.sqlite3"
  },
  'test' => {
    'adapter' => 'sqlite3',
    'pool' => 5,
    'timeout' => 5000,
    'database' => 'db/test.sqlite3'
  },
  'production' => {
    'adapter' => 'sqlite3',
    'pool' => 5,
    'timeout' => 5000,
    'database' => "#{RAILS_HOME}/db/production.sqlite3"
  }
} unless defined?(DATABASE_CONFIG)

DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'

ActiveRecord::Base.establish_connection(DATABASE_CONFIG[DATABASE_ENV])
