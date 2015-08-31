class History < ActiveRecord::Base
  belongs_to :weather
  belongs_to :user
end
