require 'test_helper'

class SpendTest < ActiveSupport::TestCase
  test "spends" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    card.recharge(wallet1, 100_00, 'r1', {})
    assert_equal 100_00, wallet1.balance

    food = Revenue.where(ref: 'food').first_or_create
    assert_equal 0, food.balance

    wallet1.spend(food, 50_00, 'samosa', {})
    assert_equal 50_00, food.balance
    assert_equal 50_00, wallet1.balance

    tickets = Revenue.where(ref: 'tickets').first_or_create
    assert_equal 0, tickets.balance

    wallet1.spend(tickets, 40_00, 'movie', {})
    assert_equal 40_00, tickets.balance
    assert_equal 50_00, food.balance
    assert_equal 10_00, wallet1.balance

    wallet1.spend(food, 5_00, 'cutlet', {})
    assert_equal 55_00, food.balance
    assert_equal 5_00, wallet1.balance

    assert_raises(DoubleEntry::AccountWouldBeSentNegative) do
      wallet1.spend(tickets, 40_00, 'movie2', {})
    end

    assert_equal 0, [card, wallet1, food, tickets].map(&:balance).sum
  end

  test "idempotency" do
    card = Recharger.where(ref: 'card').first_or_create
    wallet1 = Wallet.where(ref: 'user1').first_or_create
    card.recharge(wallet1, 100_00, 'r1', {})
    assert_equal 100_00, wallet1.balance

    food = Revenue.where(ref: 'food').first_or_create
    assert_equal 0, food.balance

    10.times { wallet1.spend(food, 50_00, 'samosa', {}) }
    assert_equal 50_00, food.balance
    assert_equal 50_00, wallet1.balance

    tickets = Revenue.where(ref: 'tickets').first_or_create
    assert_equal 0, tickets.balance

    wallet1.spend(tickets, 40_00, 'samosa', {})
    # No new spend will be registered. This ref is already being used.
    assert_equal 0, tickets.balance
    assert_equal 50_00, food.balance
    assert_equal 50_00, wallet1.balance

    assert_equal 0, [card, wallet1, food, tickets].map(&:balance).sum
  end
end
