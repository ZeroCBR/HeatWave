module Messenger
  ##
  # Joins Rules, Weather, Locations, and Users to determine
  # who needs to be sent a warning message.
  #
  module Joiner
    CONTENT = 'Heatwave Alert!' # TODO: customise in rule table.

    ##
    # Produces an array of messages which currently need to be sent
    # according to the rules in an array.
    #
    # All messages required for any of the rules will be included
    # in the output.
    #
    # ==== Parameters:
    #
    # * +models+ - a hash containing:
    #   * +:weather+ - the weather model class
    #   * +:user+ - the user model class
    #   * +:message+ - the message model class
    # * +rules+ - an array containing all of the rules of interest.
    # * +start_date+ - the start date for rule application.
    #   The method checks whether each rule is satisfied by the sequences
    #   of weather events starting at this date.
    #
    # ==== Returns:
    #
    # * An array of message model objects which need to be sent.
    #
    def self.messages(models, rules, start_date)
      rule_triggerings = Hash[
        rules.map { |rule| [rule, triggerings(models, rule, start_date)] }]

      messages = rule_triggerings.map do |rule, weathers|
        weathers.map do |w|
          send_messages_for(models, rule, w)
        end
      end
      messages.flatten
    end

    ##
    # Produces a list of triggerings for a particular rule starting at
    # a particular date.
    #
    # ==== Parameters:
    #
    # * +models+ - a hash containing:
    #   * +:location+ - the weather model class
    # * +rule+ - a single Rule model object.
    # * +start_date+ - the start date for rule application.
    #   The method checks whether each rule is satisfied by the sequences
    #   of weather events starting at this date.
    #
    # ==== Returns:
    #
    # * An array of weather model objects for the start of each
    #   weather sequence which triggers the rule.
    #
    def self.triggerings(models, rule, start_date)
      date_range = start_date...(start_date + rule.duration)

      # for each location:
      #   list all weather events at that location in the date range
      runs = models[:location].all
             .map { |location| location.weather_run(date_range) }
             .select { |run| run.size == rule.duration }

      # for each event list:
      #   for each event:
      #      if it doesn't satisfy the rule, go to next list
      #   record the triggering
      runs.select { |run| run.all? { |w| rule.satisfied_by? w } }
        .map(&:first)
    end

    ##
    # Produces a list of recipients for messages triggered by
    # a particular rule at a particular location.
    #
    # ==== Parameters:
    #
    # * +_rule+ - TODO not yet used, but it will be used eventually.
    # * +location+ - the location where the potential recipients live.
    #
    # ==== Returns:
    #
    # * An array of user model objects for the required recipients.
    #
    def self.recipients(_rule, location)
      # Note, _rule is not currently used, because attributes are not checked.
      location.users
    end

    private

    def self.send_messages_for(models, rule, weather)
      recipients = recipients(rule, weather.location)
      recipients.map do |r|
        models[:message].new(rule: rule,
                             weather: weather,
                             user: r,
                             contents: CONTENT)
      end
    end
  end
end
