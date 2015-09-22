module Messenger
  ##
  # Joins Rules, Weather, Locations, and Users to determine
  # who needs to be sent a warning message.
  #
  module Joiner
    ##
    # Produces a list of messages which currently need to be sent
    # according to a particular rule.
    #
    # ==== Parameters:
    #
    # * +models+ - a hash containing:
    #   * +:weather+ - the weather model class
    #   * +:user+ - the user model class
    #   * +:message+ - the message model class
    # * +rule+ - the rule of interest.
    # * +date_range+ - TODO
    #
    # ==== Returns:
    #
    # * An array of message model objects which need to be sent.
    #
    def messages(models, rules, date_range)
      fail 'not implemented'
    end

    private

    # Produces a list of triggerings for a particular rule over
    # a particular date range.
    #
    # ==== Parameters:
    #
    # * +models+ - a hash containing:
    #   * +:weather+ - the weather model class
    # * +date_range+ - TODO
    #
    # ==== Returns:
    #
    # * An array of hashes, one per rule trigger, containing:
    #   * +:rule+ - the model object for the triggered rule
    #   * +:weather+ - the model object for the earliest
    #     triggering weather event.
    #
    def triggerings(models, rules, date_range)
      fail 'not implemented'
    end

    # Produces a list of recipients for messages triggered by
    # a particular rule at a particular location.
    #
    # ==== Parameters:
    #
    # * +models+ - a hash containing:
    #   * +:user+ - the user model class
    # * +date_range+ - TODO
    #
    # ==== Returns:
    #
    # * An array of user model objects for the required recipients.
    #
    def recipients(models, rule, location)
      fail 'not implemented'
    end
  end
end
