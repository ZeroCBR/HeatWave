##
# Persists and provides access to data on individual messages.
#
class Message < ActiveRecord::Base
  validates :user, presence: true
  validates :weather, presence: true
  validates :rule, presence: true

  belongs_to :user
  belongs_to :weather
  belongs_to :rule
end
