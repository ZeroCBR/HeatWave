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
    FIRST_MAX_FIELD = 7 #

    ## The field delimitter for the input content.
    DELIMITTER = '#'

    ## The header line which must be present in all valid content.
    HEADER = \
      'loc_id#location#state#forecast_date#issue_date#issue_time#min_0#max_0' \
      '#min_1#max_1#min_2#max_2#min_3#max_3#min_4#max_4#min_5#max_5#min_6' \
      '#max_6#min_7#max_7#forecast_0#forecast_1#forecast_2#forecast_3' \
      "#forecast_4#forecast_5#forecast_6#forecast_7#\n"

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
    # * A hash mapping region ids to an array of their next seven
    #   forecasted maximum temperatures.
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
    # * A hash mapping region names to an array of their next seven
    #   forecasted maximum temperatures.
    #
    # ==== Raises
    #
    # * +FormatError+ if the lines are misformatted.
    #
    def self.data_by_name(lines)
      data(NAME_FIELD, lines)
    end

    ##
    # Processes weather data from its source form to
    # a form suitable for marshaling using region name as
    # the default key.
    #
    module ByName
      ##
      # Extracts from the supplied content lines the weather data
      # they contain using region name as the key.
      #
      # ==== Parameters
      #
      # * +lines+ - an array of strings, one per weather data line,
      #   starting with the header line.
      #
      # ==== Returns
      #
      # * A hash mapping region ids to an array of their next seven
      #   forecasted maximum temperatures.
      #
      # ==== Raises
      #
      # * +FormatError+ if the lines are misformatted.
      #
      def self.data_in(lines)
        Processor.data(NAME_FIELD, lines)
      end
    end

    ##
    # Raised by +Puller::Getter::data_in+ if the supplied lines don't
    # include a valid header.
    class FormatError < StandardError; end

    private

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

    def self.data(id_field, lines)
      data = {}

      fail FormatError, 'missing header' unless lines.first == HEADER

      lines.drop(1).each do |line|
        fields = line.split(DELIMITTER)
        id = fields[id_field]
        field_indices = indices_for(fields)
        data[id] = field_indices.map { |i| fields[i].to_i }
      end

      data
    end
  end
end
