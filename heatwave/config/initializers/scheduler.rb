# Only run this when the application is being run as a web server.
# That way, we don't have a million scheduled tasks from things
# like installation and testing.
if Rails.const_defined? 'Server'
  require 'rufus-scheduler'

  scheduler = Rufus::Scheduler.new
  PULL_WEATHER = 'puller'
  PULL_LOCATION = 'puller location'
  SEND_MESSAGES = 'messenger'

  min = Time.zone.now.min + 1
  hour = Time.zone.now.hour

  scheduler.cron "#{min} #{hour} * * *" do
    # Allow puts here because it's only there to give instant feedback
    # to the user:
    # rubocop:disable Rails/Output
    p format('The scheduler is working at %02d:%02d', hour, min)
    # rubocop:enable Rails/Output
  end

  scheduler.in '3s' do
    system(PULL_LOCATION)
    system(PULL_WEATHER)
  end

  # Pull weather data four times daily.
  # Don't just pull once, since the site might go down, and the forecast may
  # change.
  # Don't repeatedly try to repull constantly until it works, since we could
  # end up DDoSing ourselves.

  scheduler.cron '00 09 * * *' do
    system(PULL_WEATHER)
  end

  scheduler.cron '00 15 * * *' do
    system(PULL_WEATHER)
  end

  scheduler.cron '00 21 * * *' do
    system(PULL_WEATHER)
  end

  scheduler.cron '00 03 * * *' do
    system(PULL_WEATHER)
  end

  # Run the messenger at noon.
  # Do this once per day to not hassle people,
  # and away from weather pulling to balance load.
  scheduler.cron '00 12 * * *' do
    system(SEND_MESSAGES)
  end
end
