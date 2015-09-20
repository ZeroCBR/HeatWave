require 'date'

module Puller
  module Location
    ##
    # Processes location data from its source form to
    # a form suitable for marshaling.
    #
    module Processor
      MARKER = '"Mean maximum temperature (Degrees C)"'

      FIRST_TEMPERATURE_FIELD = 1

      ##
      # Extracts from the supplied content lines the location data
      # they contain.
      #
      # There must be a line including +MARKER+, where the mean
      # temperatures will be extracted from.
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
      # * +FormatError+ if the header line is malformed or there is
      #   no marked data line.
      #
      def self.data_in(lines)
        match_data = HEADER.match lines[0]
        fail FormatError, 'header missing' unless match_data

        data_line = lines.find { |line| line.include?(MARKER) }
        fail FormatError, 'no marked data line' unless data_line

        data_for(match_data, data_line)
      end

      class FormatError < StandardError; end

      private

      def self.data_for(match_data, data_line)
        fields = data_line.split(',').drop(FIRST_TEMPERATURE_FIELD)
        floats = fields.map(&:to_f)

        field_hash = hash_for(floats)

        { id: match_data[2], name: match_data[1] }.merge(field_hash)
      end

      def self.hash_for(fields)
        { jan_mean: fields[0], feb_mean: fields[1], mar_mean: fields[2],
          apr_mean: fields[3], may_mean: fields[4], jun_mean: fields[5],
          jul_mean: fields[6], aug_mean: fields[7], sep_mean: fields[8],
          oct_mean: fields[9], nov_mean: fields[10], dec_mean: fields[11] }
      end

      # Matches the location name in the first group and
      # location id in the second group.
      HEADER = /"[a-zA-Z ]+ '([a-zA-Z ]+)' \[(\d{6})\]"/
    end
  end
end
