module Puller
  module Location
    ##
    # Marshals location data to the database using
    # ActiveRecord models.
    #
    module ModelMarshaler
      ## Sets the Location model to use for marshaling.
      def self.location_model=(model)
        @location_model = model
      end

      ## Retrieves the Location model currently used for marshaling.
      def self.location_model
        @location_model
      end

      ##
      # Marshals location data for a single location to the database.
      #
      # ==== Parameters
      #
      # * +data+ - a hash containing:
      #   * +:id+ - the id of the location
      #   * +:name+ - the name of
      #   * +:jan_average+ - the average high temperature for the
      #     region in january.
      #   * +:feb_average+ - the average high temperature for the
      #     region in february.
      #   * +:XXX_average+ - the average high temperature for the
      #     region for each other month.
      #
      # ==== Returns
      #
      # +true+ if the location was location already existed,
      # otherwise +false+.
      #
      def self.dump(_data)
        fail 'not implemented'
      end
    end
  end
end
