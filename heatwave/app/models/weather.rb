##
# Persists and provides access to data on weather events.
#
class Weather < ActiveRecord::Base
  belongs_to :location
  has_many :histories

  def self.update_or_create_by(target, change)
    weather = find_by target
    if weather
      weather.update change
      weather
    else
      create(target.merge(change))
    end
  end
end
