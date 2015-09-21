require 'net/http'

module Puller
  module Location
    ##
    # A custom marshaler for a weather pulling pipeline which
    # loops through the weather data, attempting to pull location
    # for each location with a forecast.
    class Looper
      SOURCE = \
        'http://www.bom.gov.au/clim_data/cdio/tables/text/IDCJCM0035_%s.csv'

      attr_accessor :puller

      def initialize(puller)
        @puller = puller
      end

      ##
      # Loops through the weather data, attempting to pull location
      # for each location with a forecast.
      #
      # Failure resilient; if a particular location cannot be pulled,
      # the entire operation won't be aborted.
      #
      # ==== Parameters
      #
      # * +data+ - a hash with location ids as the keys.
      #
      # ==== Returns
      #
      # * The number of locations which were successfully pulled.
      #
      def dump(data)
        results = data.keys.map do |l_id|
          begin
            @puller.pull_from(URI(SOURCE % l_id))
            1
          rescue Net::HTTPBadResponse, URI::InvalidURIError
            0
          end
        end
        results.sum
      end
    end
  end
end
