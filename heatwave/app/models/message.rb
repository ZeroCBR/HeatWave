##
# Persists and provides access to data on individual messages.
#
class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :weather
  belongs_to :rule
end
