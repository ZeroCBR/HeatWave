class Location < ActiveRecord::Base
  has_many :weather

  def self.update_or_create(target)
    location = find_by target[:id]
    if location
      location.update target
    else
      create target
    end
  end
end
