module Messenger
  ##
  # module for sending sms
  #
  module SmsWrapper
    ##
    # sends a given message by sms
    #
    # ==== Parameters
    #
    # * An ActiverRecord for a Message
    #
    # ==== Returns:
    #
    # * the response code for that message from telstra
    #
    def self::send_via_sms(message)
      content = message.contents
      if content.length > 160
        fail SmsTooLongError, "Sms length: #{content.length}"
      else
        number = message.user.phone
        message.send_time = DateTime.now
        SmsSender.sender_object.send(number, content)
      end
    end

    class SmsTooLongError < StandardError; end
  end
end
