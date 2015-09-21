##
# Persists and provides access to location and weather station data.
#
class Location < ActiveRecord::Base
  has_many :weather

  def self.update_or_create(target)
    location = find_by(id: target[:id])
    if location
      location.update target
      location
    else
      create target
    end
  end
end
