require 'date'

module Puller
  ##
  # Processes weather data from its source form to
  # a form suitable for marshaling.
  #
  module Processor
    ## Field index of the region id.
    ID_FIELD = 0

    ## Field index of the region name.
    NAME_FIELD = 1

    ## Number of max temperature fields per line.
    NUM_MAX_FIELDS = 7

    ## Step between max temperature field indices.
    MAX_FIELD_DELTA = 2

    ## First max temperature field index.
    FIRST_MAX_FIELD = 7

    ## The field delimitter for the input content.
    DELIMITTER = '#'

    ## The header line which must be present in all valid content.
    HEADER = \
      'loc_id#location#state#forecast_date#issue_date#issue_time#min_0#max_0' \
      '#min_1#max_1#min_2#max_2#min_3#max_3#min_4#max_4#min_5#max_5#min_6' \
      '#max_6#min_7#max_7#forecast_0#forecast_1#forecast_2#forecast_3' \
      '#forecast_4#forecast_5#forecast_6#forecast_7#'

    ##
    # Extracts from the supplied content lines the weather data they
    # contain using region id as the key.
    #
    # ==== Parameters
    #
    # * +lines+ - an array of strings, one per weather data line,
    #   starting with the header line.
    #
    # ==== Returns
    #
    # * A hash mapping region ids to an array of hashes for the
    #   next seven forecasted days containing:
    #   * +:date+ - the date of the forecast
    #   * +:max_temp+ - the maximum temperature forecasted for that day.
    #
    # ==== Raises
    #
    # * +FormatError+ if the lines are misformatted.
    #
    def self.data_in(lines)
      data(ID_FIELD, lines)
    end

    ##
    # Extracts from the supplied content lines the weather data they
    # contain using region name as the key.
    #
    # ==== Parameters
    #
    # * +lines+ - an array of strings, one per weather data line,
    #   starting with the header line.
    #
    # ==== Returns
    #
    # * A hash mapping region names to an array of hashes for the
    #   next seven forecasted days containing:
    #   * +:date+ - the date of the forecast
    #   * +:max_temp+ - the maximum temperature forecasted for that day.
    #
    # ==== Raises
    #
    # * +FormatError+ if the lines are misformatted.
    #
    def self.data_by_name(lines)
      data(NAME_FIELD, lines)
    end

    ##
    # Raised by +Puller::Getter::data_in+ if the supplied lines don't
    # include a valid header.
    class FormatError < StandardError; end

    private

    # Returns the temperature fields which are to be used for
    # a given set of fields.
    # Skips either the first or the last maximum temperature field,
    # depending on which one is populated.
    def self.indices_for(fields)
      if fields[FIRST_MAX_FIELD] == ''
        min = FIRST_MAX_FIELD + MAX_FIELD_DELTA
        max = FIRST_MAX_FIELD + (NUM_MAX_FIELDS) * MAX_FIELD_DELTA
      else
        min = FIRST_MAX_FIELD
        max = FIRST_MAX_FIELD + (NUM_MAX_FIELDS - 1) * MAX_FIELD_DELTA
      end
      (min..max).step(MAX_FIELD_DELTA)
    end

    # Returns a hash mapping locations to a hash containing their forecast.
    # The weather data is taken from +lines+, using field number
    # +id_field+ for the hash keys.
    #
    # eg. { '123456' => { <today> => 10, <tomorow> => 12, etc. } }
    def self.data(id_field, lines)
      fail FormatError, 'missing header' unless lines.first == HEADER

      all_data = lines.drop(1).map do |line|
        fields = line.split(DELIMITTER)
        [fields[id_field], line_data(fields)]
      end

      Hash[all_data]
    end

    # Returns a hash mapping dates to the forecasted high temperature
    # for those dates.
    def self.line_data(fields)
      field_indices = indices_for(fields)
      dates = field_indices
              .map { |i| (i - field_indices.first) }
              .map { |i| i / MAX_FIELD_DELTA }
              .map { |i| Date.today + i }
      temperatures = field_indices.map { |i| fields[i].to_f }

      Hash[dates.zip temperatures]
    end
  end
end
