require 'test_helper'

class RechargeTest < ActiveSupport::TestCase
  test "recharges" do
    card = Recharger.where(ref: 'card').first_or_create
    assert_equal 0, card.balance
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    assert_equal 0, wallet1.balance

    card.recharge(wallet1, 100_00, 'r1', {})

    assert_equal -100_00, card.balance
    assert_equal 100_00, wallet1.balance

    wallet2 = Wallet.where(ref: 'user2').first_or_create
    card.recharge(wallet2, 100_00, 'r2', {})

    assert_equal -200_00, card.balance
    assert_equal 100_00, wallet1.balance
    assert_equal 100_00, wallet2.balance

    assert_equal 0, [card, wallet1, wallet2].map(&:balance).sum
  end

  test "idempotency" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    assert_equal 0, wallet1.balance

    card.recharge(wallet1, 100_00, 'r1', {})
    card.recharge(wallet1, 100_00, 'r1', {})
    card.recharge(wallet1, 100_00, 'r1', {})

    assert_equal -100_00, card.balance
    assert_equal 100_00, wallet1.balance
    assert_equal 1, Transaction.count

    wallet2 = Wallet.where(ref: 'user2').first_or_create
    card.recharge(wallet2, 100_00, 'r1', {})
    card.recharge(wallet2, 100_00, 'r1', {})
    card.recharge(wallet2, 100_00, 'r1', {})

    assert_equal -100_00, card.balance
    assert_equal 100_00, wallet1.balance
    assert_equal 0, wallet2.balance
    assert_equal 1, Transaction.count

    assert_equal 0, [card, wallet1, wallet2].map(&:balance).sum
  end
end
