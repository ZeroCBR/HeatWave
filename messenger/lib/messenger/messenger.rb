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
  def not_implemented
    fail 'not implemented yet'
  end

  def send_messages
    retrieve_messages.each do |msg|
      user = msg[:user]
      if user[:messages_type] == 'email'
        send_via_email(msg)
      elsif user[:messages_type] == 'phone'
        send_via_sms(msg)
      end
      msg.save!
    end
  end

  def retrieve_messages
    models = {
      location: Messenger::Models::Location,
      message:  Messenger::Models::Message,
      user:     Messenger::Models::User
    }
    Messenger::Joiner.messages(models, Rule.all, nil)
  end

  private
  
  def send_via_sms(msg)
    SmsSender::ExampleSender.send(msg[:user][:phone], msg[:contents])
    msg[:send_time] = DateTime.now
  end

  def send_via_email(msg)
    MailExample.example_send(msg[:user][:email], msg[:contents])
    msg[:send_time] = DateTime.now
  end
end
