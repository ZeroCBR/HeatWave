class History < ActiveRecord::Base
	has_one :weather
	has_many :users
end
