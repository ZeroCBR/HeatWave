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
    # No return value contract.
    #
    def self.dump(data)
      data.each_pair do |location_id, events|
        # Skip nil locations.
        location = @location_model.find(location_id) || next

        events.each_pair do |date, high_temp|
          @weather_model.create(location: location,
                                date: date,
                                high_temp: high_temp)
        end
      end
    end
  end
end
