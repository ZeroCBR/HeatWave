require 'date'
require 'sms_sender'
require 'mail_example'
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
  # * An array of booleans as to whether they were saved in the database.
  #
  def self::send_messages(messages, sender = nil)
    saved_states = []
    messages.each do |msg|
      switch_method(msg, sender)
      if msg.methods.include? :save
        saved_states << msg.save
      else
        saved_states << false
      end
    end
  end

  def self::switch_method(msg, sender = nil)
    sender ||= ExampleMessageSender.new
    user = msg[:user]
    if user[:messages_type] == 'email'
      sender.send_via_email(msg)
    elsif user[:messages_type] == 'phone'
      sender.send_via_sms(msg)
    end
  end

  ##
  # Retrieves a list of messages to be sent from the Big Join algorithm,
  # For each rule in the database.
  #
  # ==== Returns:
  #
  # * An array of message hashes which haven't been sent yet.
  #
  def self::retrieve_messages(stub = false)
    models = {
      location: Location,
      message:  Message,
      user:     User
    }
    if !stub
      Messenger::Joiner.messages(models, Rule.all, Date.today)
    else
      return models
    end
  end

  ##
  # Example class with the two send methods.
  #
  class ExampleMessageSender
    include Messenger
    def send_via_sms(msg)
      content = msg[:contents]
      number = msg[:user][:phone]
      SmsSender.sender_object.send(number, content)
      msg[:send_time] = DateTime.now
    end

    def send_via_email(msg)
      MailExample.example_send(msg[:user][:email], msg[:contents])
      msg[:send_time] = DateTime.now
    end
  end
end
