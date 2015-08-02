require 'test_helper'

class RechargerTest < ActiveSupport::TestCase
  test "recharges" do
    card = Recharger.where(ref: 'card').first_or_create
    assert_equal card.balance, 0
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    assert_equal wallet1.balance, 0

    card.recharge(wallet1, 100_00, 'r1', {})

    assert_equal card.balance, -100_00
    assert_equal wallet1.balance, 100_00

    wallet2 = Wallet.where(ref: 'user2').first_or_create
    card.recharge(wallet2, 100_00, 'r2', {})

    assert_equal card.balance, -200_00
    assert_equal wallet1.balance, 100_00
    assert_equal wallet2.balance, 100_00
  end

  test "idempotency" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    assert_equal wallet1.balance, 0

    card.recharge(wallet1, 100_00, 'r1', {})
    card.recharge(wallet1, 100_00, 'r1', {})
    card.recharge(wallet1, 100_00, 'r1', {})

    assert_equal card.balance, -100_00
    assert_equal wallet1.balance, 100_00
    assert_equal Transaction.count, 1

    wallet2 = Wallet.where(ref: 'user2').first_or_create
    card.recharge(wallet2, 100_00, 'r1', {})
    card.recharge(wallet2, 100_00, 'r1', {})
    card.recharge(wallet2, 100_00, 'r1', {})

    assert_equal card.balance, -100_00
    assert_equal wallet1.balance, 100_00
    assert_equal wallet2.balance, 0
    assert_equal Transaction.count, 1

  end
end
