ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  ##
  # Test helpers for model tests.
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in
    # alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionController
  ##
  # Test helpers for controller tests.
  class TestCase
    # Prevent authentication errors in testing.
    include Devise::TestHelpers
  end
end
