require 'test_helper'

class RechargesControllerTest < ActionController::TestCase
  test "recharges" do
    transaction_ref = SecureRandom.uuid
    r1 = Recharger.where(ref: "CARD").first_or_create!
    w1 = Wallet.where(ref: "wallet1").first_or_create!

    post :create, {
      ref: "ABCD1234",
      wallet: w1.ref,
      recharger: r1.ref,
      amount: 4200,
      data: {
        "k1": "v1"
      },
      token: ENV['TOKEN']
    }
    assert_equal "v1", Recharge.where(ref: "ABCD1234").first.data["k1"]

    assert_equal -42_00, r1.balance
    assert_equal 42_00, w1.balance
    assert_equal 0, [w1, r1].map(&:balance).sum

    3.times do
      post :create, {
        ref: "ABCD1234",
        wallet: w1.ref,
        recharger: r1.ref,
        amount: 4200,
        data: {
          "k1": "v2"
        },
        token: ENV['TOKEN']
      }
    end

    assert_equal "v1", Recharge.where(ref: "ABCD1234").first.data["k1"]
    # Transaction metadata should be immutable. Only account metadata is mutable.

    assert_equal -42_00, r1.balance
    assert_equal 42_00, w1.balance
    assert_equal 0, [w1, r1].map(&:balance).sum
  end
end
