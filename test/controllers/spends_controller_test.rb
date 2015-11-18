require 'test_helper'

class SpendsControllerTest < ActionController::TestCase
  test "spends" do
    transaction_ref = SecureRandom.uuid
    w1 = Wallet.where(ref: "wallet1").first_or_create!
    r1 = Revenue.where(ref: 'food').first_or_create!
    re1 = Recharger.where(ref: 'card').first_or_create!
    re1.recharge w1, 50_00, SecureRandom.uuid

    post :create, {
      ref: "ABCD1234",
      wallet: w1.ref,
      revenue: r1.ref,
      amount: 4200,
      data: {
        "k1": "v1"
      },
      token: ENV['TOKEN']
    }

    assert_equal 42_00, r1.balance
    assert_equal 8_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum

    3.times do
      post :create, {
        ref: "ABCD1234",
        wallet: w1.ref,
        revenue: r1.ref,
        amount: 4200,
        data: {
          "k1": "v1"
        },
        token: ENV['TOKEN']
      }
    end

    assert_equal 42_00, r1.balance
    assert_equal 8_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum
  end

  test "overspends" do
    transaction_ref = SecureRandom.uuid
    w1 = Wallet.where(ref: "wallet1").first_or_create!
    r1 = Revenue.where(ref: 'food').first_or_create!
    re1 = Recharger.where(ref: 'card').first_or_create!
    re1.recharge w1, 50_00, SecureRandom.uuid

    post :create, {
      ref: "ABCD1234",
      wallet: w1.ref,
      revenue: r1.ref,
      amount: 42_00,
      data: {
        "k1": "v1"
      },
      token: ENV['TOKEN']
    }

    assert_equal 42_00, r1.balance
    assert_equal 8_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum

    3.times do
      assert_raises DoubleEntry::AccountWouldBeSentNegative do
        post :create, {
          ref: "XYZ1234",
          wallet: w1.ref,
          revenue: r1.ref,
          amount: 10_00,
          data: {
            "k1": "v1"
          },
          token: ENV['TOKEN']
        }
      end
    end

    assert_equal 42_00, r1.balance
    assert_equal 8_00, w1.balance
    assert_equal 0, [w1, r1, re1].map(&:balance).sum
  end

end
