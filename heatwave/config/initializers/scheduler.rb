require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new
PULLER_PATH = '../puller/'
PULL_WEATHER = 'puller'
PULL_LOCATION = 'puller location'

scheduler.in '3s' do
  system('cd ' + PULLER_PATH + ' && ' + PULL_WEATHER)
  system('cd ' + PULLER_PATH + ' && ' + PULL_LOCATION)
end

scheduler.every '87300s' do
  system('cd ' + PULLER_PATH + ' && ' + PULL_WEATHER)
end
