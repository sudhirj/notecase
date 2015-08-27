ENV['RAILS_ENV'] ||= 'test'
ENV['TOKEN'] ||= 'ABCD1234'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  DoubleEntry::Locking.configure do |config|
    config.running_inside_transactional_fixtures = true
  end

  # ActiveRecord::Base.logger = Logger.new(STDOUT)
end
