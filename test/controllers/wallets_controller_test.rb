require 'test_helper'

class WalletsControllerTest < ActionController::TestCase
  include AccountControllerTester

  def model
    Wallet
  end
end
