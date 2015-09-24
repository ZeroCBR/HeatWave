require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

scheduler.in '5s' do
	 system('cd ../puller/ && puller')
end

scheduler.every '30s' do
	system('cd ../puller/ && puller')
end