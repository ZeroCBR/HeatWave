class Weather < ActiveRecord::Base
  belongs_to :location
  has_many :histories

  def self.find_and_update_or_create_by(target, change)
    weather = find_by target
    if weather
      weather.update change
    else
      create(target.merge(change))
    end
  end
end
