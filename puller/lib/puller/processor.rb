module Puller
  ##
  # Processes weather data from its source form to
  # a form suitable for persistance.
  module Processor
    ID_FIELD = 0
    NUM_FIELDS = 7
    FIELD_SEP = 2
    MIN_FIELD = 9
    MAX_FIELD = MIN_FIELD + NUM_FIELDS * FIELD_SEP
    MAX_FIELDS = (MIN_FIELD...MAX_FIELD).step(FIELD_SEP)
    DELIMITTER = '#'

    HEADER = \
      'loc_id#location#state#forecast_date#issue_date#issue_time#min_0#max_0' \
      '#min_1#max_1#min_2#max_2#min_3#max_3#min_4#max_4#min_5#max_5#min_6' \
      '#max_6#min_7#max_7#forecast_0#forecast_1#forecast_2#forecast_3' \
      "#forecast_4#forecast_5#forecast_6#forecast_7#\n"

    def self.data_in(lines)
      data = {}

      fail FormatError, 'missing header' unless lines.first == HEADER

      lines.drop(1).each do |line|
        fields = line.split(DELIMITTER)
        id = fields[ID_FIELD].to_i
        data[id] = MAX_FIELDS.map { |i| fields[i].to_i }
      end

      data
    end

    class FormatError < StandardError; end
  end
end
