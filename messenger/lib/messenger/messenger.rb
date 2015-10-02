require 'date'
require 'sms_sender'
require 'mail'
require 'messenger/version'
require 'messenger/models'

##
# Sends the messages at the core of this application.
#
# Sends messages:
#
# * to people registered in the database,
# * using the communication methods defined in the database,
# * according to rules predefined in the database,
# * triggered by weather updates in the database,
# * which occur in the same location the recipients live in.
#
module Messenger
  ##
  # Retreives a list of messages to be sent, and then
  # sends each message to its recipient via the method
  # that the recipient has requested.
  #
  # ==== Parameters:
  #
  # * +messages+ a list of messages to be sent
  # * +sender+ the object to use to send the messages
  #
  # ==== Returns:
  #
  # * A list of hashes of the form {message, error}
  #    i.e. a message that could not be sent and the relevant error
  #
  def self::send_messages(messages, sender = nil)
    errors = []
    messages.each do |message|
      begin send_one_message(message, sender)
      rescue MessengerError => e
        errors << { message: message, error: e }
        next
      end
      message.save
    end
    return errors
  end

  ##
  # Retrieves a list of messages to be sent from the Big Join algorithm,
  # For each rule in the database.
  #
  # ==== Parameters:
  #
  # * OPTTIONAL: a 'joiner' object with a .messages method
  #
  # ==== Returns:
  #
  # * An array of message hashes which haven't been sent yet.
  #
  def self::retrieve_messages(joiner = Messenger::Joiner)
    models = {
      location: Location,
      message:  Message,
      user:     User
    }
    joiner.messages(models, Rule.all, Date.today)
  end

  class MessengerError < StandardError; end
  class MessageTypeError < Messenger::MessengerError; end

  private

  # text for the error message when message_type is set wrong
  WRONGMETHODERROR = "'message_type' must be set to 'email' or 'phone'."\
    ' In this case it was: '

  def self::send_one_message(message, sender = nil)
    case message.user.message_type
    when 'phone'
      sender ||= SmsWrapper
      sender.send_via_sms(message)
    when 'email'
      sender ||= EmailWrapper
      sender.send_via_email(message)
    else
      fail MessageTypeError, WRONGMETHODERROR + message.user.message_type
    end
  end

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

    class SmsTooLongError < Messenger::MessengerError; end
  end

  ##
  # Module for sending Emails
  #
  module EmailWrapper
    ##
    # Sends a message using the Mail gem
    #
    # ==== Parameters:
    # message: A message ActiveRecord object from our DB
    #
    # ==== Returns
    # true if sent correctly
    #
    def self::send_via_email(message)
      details = create_email_details(message)

      options = options_for details

      Mail.defaults do
        delivery_method :smtp, options
      end
      message.send_time = DateTime.now
      deliver_mail(details)
    end

    private

    def self::deliver_mail(details)
      Mail.deliver do
        to details[:recipient]
        from details[:user_name]
        subject details[:subject]
        body details[:message]
      end
    end

    def self::create_email_details(message)
      {
        user_name: 'heatwaveorange@gmail.com',
        password: 'heatwaveorange1234',
        recipient: message.user.email,
        subject: 'HeatWave Alert',
        message: message.contents
      }
    end

    def self::options_for(details)
      {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               'your.host.name',
        user_name:            details[:user_name],
        password:             details[:password],
        authentication:       'plain',
        enable_ssl:           true,
        enable_starttls_auto: true
      }
    end
  end
end
