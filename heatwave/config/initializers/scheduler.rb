require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new
PULL_WEATHER = 'puller'
PULL_LOCATION = 'puller location'
SEND_MESSAGES = 'messenger'

scheduler.in '3s' do
  system("cd #{ENV['PULLER_HOME']} && #{PULL_LOCATION}")
  system("cd #{ENV['PULLER_HOME']} && #{PULL_WEATHER}")
end

# Pull weather data four times daily.
# Don't just pull once, since the site might go down, and the forecast may
# change.
# Don't repeatedly try to repull constantly until it works, since we could
# end up DDoSing ourselves.
scheduler.every '6h' do
  system("cd #{ENV['PULLER_HOME']} && #{PULL_WEATHER}")
end

# Run the messenger a while after the puller, for load balancing.
scheduler.in '1h' do
  scheduler.every '24h' do
    system("cd #{ENV['MESSENGER_HOME']} && bundle exec #{SEND_MESSAGES}")
  end
end
