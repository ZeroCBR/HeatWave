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
