require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

end

module AccountControllerTester
  extend ActiveSupport::Concern
  included do
    test "creating and updating" do
      def make_assertions
        assert_equal 1, model.count
        created_account = model.first
        assert_equal 'abcd1234', created_account.ref
      end

      post :create, {ref: 'abcd1234', data: {k1: 'v1'}}
      make_assertions
      assert_equal 'v1', model.first.data["k1"]

      3.times do
        post :create, {ref: 'abcd1234', data: {k1: 'v2'}}
        make_assertions
      end

      make_assertions
      assert_equal 'v2', model.first.data["k1"]

      post :create, {ref: 'efgh5678', data: {k2: 'v1'}}
      assert_equal 2, model.count
      assert_equal 'v1', model.where(ref: 'efgh5678').first.data["k2"]
    end

    def model
      raise "Subclass for tests"
    end
  end
end
