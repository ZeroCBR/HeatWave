require 'io/console'
require 'mail'

##
# Simple mail example.
module MailExample
  public

  def example_run
    details = input_details
    options = options_for details

    Mail.defaults do
      delivery_method :smtp, options
    end

    deliver_mail(details)
  end

  def deliver_mail(details)
    Mail.deliver do
      to details[:recipient]
      from details[:user_name]
      subject details[:subject]
      body details[:message]
    end
  end

  def input_details
    {
      user_name: input('enter gmail username:'),
      password: hidden_input('enter gmail password:'),
      recipient: input('enter recipient:'),
      subject: input('enter email subject:'),
      message: input('enter email body:')
    }
  end

  private

  def input(prompt)
    puts prompt
    gets
  end

  def hidden_input(prompt)
    puts prompt
    STDIN.noecho(&:gets)
  end

  def options_for(details)
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
