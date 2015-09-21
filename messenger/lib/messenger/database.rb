require 'active_record'

module Messenger
  ##
  # Defines and initialises the database to use for
  # ActiveRecord models.
  #
  module Database
    def self.initialise(database_env = nil)
      @database_env ||= database_env || ENV['DATABASE_ENV'] || \
                        ENV['RAILS_ENV'] || 'development'

      puts "Using database environment: #{@database_env}"
      return if @did_initialise

      ActiveRecord::Base.establish_connection(DATABASE_CONFIG[@database_env])
      @did_initialise = true
    end

    private

    @did_initialise = false

    # Config for Rails integration.
    RAILS_HOME ||= ENV['RAILS_HOME'] || '../heatwave'
    MESSENGER_HOME ||= ENV['MESSENGER_HOME'] || '.'

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
        'database' => "#{MESSENGER_HOME}/db/test.sqlite3"
      },
      'production' => {
        'adapter' => 'sqlite3',
        'pool' => 5,
        'timeout' => 5000,
        'database' => "#{RAILS_HOME}/db/production.sqlite3"
      }
    }
  end
end
