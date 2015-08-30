$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'puller'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
