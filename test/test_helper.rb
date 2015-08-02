ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  DoubleEntry::Locking.configure do |config|
    config.running_inside_transactional_fixtures = true
  end

  # Add more helper methods to be used by all tests here...
end
