require 'date'

module Puller
  module Location
    ##
    # Processes location data from its source form to
    # a form suitable for marshaling.
    #
    module Processor
      ##
      # Extracts from the supplied content lines the location data
      # they contain.
      #
      # ==== Parameters
      #
      # * +lines+ - an array of strings, one per location data line,
      #   starting with the header line.
      #
      # ==== Returns
      #
      # * A hash containing:
      #   * +:id+ - the id of the location
      #   * +:name+ - the name of
      #   * +:jan_average+ - the average high temperature for the
      #     region in january.
      #   * +:feb_average+ - the average high temperature for the
      #     region in february.
      #   * +:XXX_average+ - the average high temperature for the
      #     region for each other month.
      #
      # ==== Raises
      #
      # * +FormatError+ if the lines are misformatted.
      #
      def self.data_in
        fail 'not implemented'
      end
    end
  end
end
