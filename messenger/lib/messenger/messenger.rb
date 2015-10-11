require 'date'
require 'messenger/version'
require 'messenger/models'
require 'messenger/sms_wrapper'
require 'messenger/email_wrapper'

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
      rescue MessageTypeError, SmsWrapper::SmsTooLongError => e
        errors << { message: message, error: e }
        next
      else message.send_time = DateTime.now
      end
      message.save
    end; errors
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

  class MessageTypeError < StandardError; end

  private

  # text for the error message when message_type is set wrong
  WRONGMETHODERROR = "'message_type' must be set to 'email' or 'phone'."\
    ' In this case it was: '

  def self::send_one_message(message, sender = nil)
    case message.user.message_type
    when 'phone'
      send_sms(message, sender)
    when 'email'
      send_email(message, sender)
    else
      fail MessageTypeError, WRONGMETHODERROR + message.user.message_type
    end
  end

  def self::send_sms(message, sender = nil)
    message.sent_to = message.user.phone
    message.message_type = 'phone'
    sender ||= SmsWrapper
    sender.send_via_sms(message)
  end

  def self::send_email(message, sender = nil)
    message.sent_to = message.user.email
    message.message_type = 'email'
    sender ||= EmailWrapper
    sender.send_via_email(message)
  end
end
