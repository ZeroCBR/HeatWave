require 'sms_sender'
module Messenger
  ##
  # Module for sending sms messages
  #
  module SmsWrapper
    ##
    # Sends a given message by sms
    #
    # ==== Parameters
    #
    # * An ActiveRecord for a Message
    #
    # ==== Returns:
    #
    # * The Telstra ID of that message for use with responses
    #
    def self::send_via_sms(message)
      content = message.contents
      if content.length > 160
        fail SmsTooLongError, "Sms length: #{content.length}"
      else
        number = message.user.phone
        SmsSender.sender_object.send(number, content)
      end
    end

    class SmsTooLongError < StandardError; end
  end
end
