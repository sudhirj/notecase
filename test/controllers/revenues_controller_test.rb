require 'test_helper'

class RevenuesControllerTest < ActionController::TestCase
  include AccountControllerTester

  def model
    Revenue
  end
end
