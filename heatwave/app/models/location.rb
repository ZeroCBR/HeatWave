##
# Persists and provides access to location and weather station data.
#
class Location < ActiveRecord::Base
  has_many :users
  has_many :weathers

  ##
  # The weather events at this location for the given date range,
  # if they exist.
  #
  # ==== Parameters
  #
  # * +date_range+ - the range of dates to retrieve weather for.
  #
  # ==== Returns
  #
  # The array of weather (model) objects.
  #
  # If not all of the dates have associated weather events,
  # the event for that date will be ommitted silently.
  # That is, the result will just be shorter than the date range,
  # it won't have nil elements.
  #
  def weather_run(date_range)
    Weather.where(date: date_range, location: self)
  end

  ##
  # A convenience method which finds the target and
  # updates it according to the change.
  # If the target does not exist, it is created.
  #
  # ==== Parameters
  #
  # * +target+ - a hash characterising the record which should be
  #   found or created.
  # * +change+ - a hash characterising the assignments to make
  #   to the record.
  #
  # ===== Returns
  #
  # The model object for the updated or created record.
  #
  def self.update_or_create_by(target, change)
    location = find_by target
    if location
      location.update change
      location
    else
      create(target.merge(change))
    end
  end

  ##
  # Returns the monthly mean high temperature for the given date.
  #
  # ==== Parameters
  #
  # * +date+ - the Date object to retrieve the monthlhy temperature for.
  #
  # ==== Returns
  #
  # The mean temperature for the month of the given date.
  #
  def mean_for(date)
    MONTH_MEANS[date.month - 1].call(self)
  end

  MONTH_MEANS = [lambda(&:jan_mean), lambda(&:feb_mean), lambda(&:mar_mean),
                 lambda(&:apr_mean), lambda(&:may_mean), lambda(&:jun_mean),
                 lambda(&:jul_mean), lambda(&:aug_mean), lambda(&:sep_mean),
                 lambda(&:oct_mean), lambda(&:nov_mean), lambda(&:dec_mean)]
end
