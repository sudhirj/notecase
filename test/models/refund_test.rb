require 'test_helper'

class RefundTest < ActiveSupport::TestCase
  test "spends" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    food = Revenue.where(ref: 'food').first_or_create
    card.recharge(wallet1, 100_00, 'r1', {})
    wallet1.spend(food, 10_00, "user1's samosa", {})
    wallet1.spend(food, 15_00, "user1's cutlet", {})
    assert_equal 75_00, wallet1.balance
    assert_equal 25_00, food.balance

    Spend.where(ref: "user1's samosa").first.refund

    assert_equal 85_00, wallet1.balance
    assert_equal 15_00, food.balance

    assert_equal 0, [card, wallet1, food].map(&:balance).sum

    Spend.where(ref: "user1's cutlet").first.refund

    assert_equal 100_00, wallet1.balance
    assert_equal 0_00, food.balance

    assert_equal 0, [card, wallet1, food].map(&:balance).sum
  end

  test "idempotency" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    food = Revenue.where(ref: 'food').first_or_create
    card.recharge(wallet1, 100_00, 'r1', {})
    wallet1.spend(food, 10_00, "user1's samosa", {})
    wallet1.spend(food, 15_00, "user1's cutlet", {})

    10.times { Spend.where(ref: "user1's samosa").first.refund }

    assert_equal 85_00, wallet1.balance
    assert_equal 15_00, food.balance

    assert_equal 0, [card, wallet1, food].map(&:balance).sum

    3.times { Spend.where(ref: "user1's cutlet").first.refund }
    5.times { Spend.where(ref: "user1's samosa").first.refund }

    assert_equal 100_00, wallet1.balance
    assert_equal 0_00, food.balance

    assert_equal 0, [card, wallet1, food].map(&:balance).sum
  end

end
