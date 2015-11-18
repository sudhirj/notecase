require 'test_helper'

class RefundsControllerTest < ActionController::TestCase
  test "refunds" do
    transaction_ref = SecureRandom.uuid
    w1 = Wallet.where(ref: "wallet1").first_or_create!
    r1 = Revenue.where(ref: 'food').first_or_create!
    re1 = Recharger.where(ref: 'card').first_or_create!
    re1.recharge w1, 50_00, SecureRandom.uuid

    w1.spend(r1, 42_00, 'ABCD1234', {})

    assert_equal 42_00, r1.balance
    assert_equal 8_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum

    post :create, {
      ref: "ABCD1234",
      data: {
        "k1": "v1"
      },
      token: ENV['TOKEN']
    }

    assert_equal 0, r1.balance
    assert_equal 50_00, w1.balance

    3.times do
      post :create, {
        ref: "ABCD1234",
        data: {
          "k1": "v1"
        },
        token: ENV['TOKEN']
      }
    end

    assert_equal 0, r1.balance
    assert_equal 50_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum
  end
end
