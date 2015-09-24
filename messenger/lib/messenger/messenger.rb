require 'date'
require 'sms_sender'
require 'mail_example'
require 'messenger/version'

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
  def self::send_messages(messages, sender)
    messages.each do |msg|
      user = msg[:user]
      if user[:messages_type] == 'email'
        sender.send_via_email(msg)
      elsif user[:messages_type] == 'phone'
        sender.send_via_sms(msg)
      end
      saved_states << msg.save
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
  def self::retrieve_messages
    models = {
      location: Messenger::Models::Location,
      message:  Messenger::Models::Message,
      user:     Messenger::Models::User
    }
    Messenger::Joiner.messages(models, Rule.all, nil)
  end

  private

  def self.send_via_sms(msg)
    SmsSender::ExampleSender.send(msg[:user][:phone], msg[:contents])
    msg[:send_time] = DateTime.now
  end

  def self.send_via_email(msg)
    MailExample.example_send(msg[:user][:email], msg[:contents])
    msg[:send_time] = DateTime.now
  end

end
