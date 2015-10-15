require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new
PULL_WEATHER = 'puller'
PULL_LOCATION = 'puller location'
SEND_MESSAGES = 'messenger'

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

scheduler.cron "#{Time.now.min + 1} #{Time.now.hour} * * *" do
  puts 'The scheduler is working'
end
