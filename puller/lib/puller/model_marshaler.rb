module Puller
  ##
  # Marshals weather data to the database using
  # ActiveRecord models.
  #
  module ModelMarshaler
    ## Sets the Weather model to use for marshaling.
    def self.weather_model=(model)
      @weather_model = model
    end

    ## Retrieves the Weather model currently used for marshaling.
    def self.weather_model
      @weather_model
    end

    ## Sets the Location model to use for marshaling.
    def self.location_model=(model)
      @location_model = model
    end

    ## Retrieves the Location model currently used for marshaling.
    def self.location_model
      @location_model
    end

    ##
    # Marshals weather data to the database.
    #
    # The weather data must be for known locations.
    # If weather data for an unknown location is included in +data+,
    # then it will not be marshaled.
    #
    # ==== Parameters
    #
    # * +data+ - a hash mapping weather station ids to more hashes containing:
    #   * +:date+ - the date of the forecast
    #   * +:high_temp+ - the high temperature forecasted for that date
    #
    # ==== Returns
    #
    # The number of records which were dumped.
    # For example, if 2 new records are made, and 3 records are
    # updated, it will return 5.
    #
    def self.dump(data)
      total = 0

      data.each_pair do |location_id, events|
        # Skip nil locations.
        location = @location_model.find_by_id(location_id.to_i)
        next unless location
        total += dump_all(location, events)
      end

      total
    end

    private

    def self.dump_all(location, events)
      events.each_pair do |date, high_temp|
        @weather_model.find_and_update_or_create_by(
          { location: location, date: date }, high_temp: high_temp
        )
      end
      events.size
    end
  end
end
