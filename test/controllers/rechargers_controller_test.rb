require 'test_helper'

class RechargersControllerTest < ActionController::TestCase
  include AccountControllerTester

  def model
    Recharger
  end
end
