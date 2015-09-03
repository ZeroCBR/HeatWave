require 'io/console'
require 'mail'

##
# Simple mail example.
module MailExample
  def self::example_send(recipient, message)
    details = {
      user_name: 'heatwaveorange@gmail.com',
      password: 'heatwaveorange1234',
      recipient: recipient,
      subject: 'HeatWave Alert',
      message: message,
    }

    options = options_for details

    Mail.defaults do
      delivery_method :smtp, options
    end

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
