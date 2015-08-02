require 'double_entry'

Money.default_currency = Money::Currency.new(ENV["DEFAULT_CURRENCY"] || "INR")

DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    accounts.define(identifier: :wallet, scope_identifier: accounts.active_record_scope_identifier(Wallet), positive_only: true)
    accounts.define(identifier: :recharger, scope_identifier: accounts.active_record_scope_identifier(Recharger))
    accounts.define(identifier: :revenue, scope_identifier: accounts.active_record_scope_identifier(Revenue), positive_only: true)
  end

  config.define_transfers do |transfers|
    transfers.define(code: :recharge, from: :recharger, to: :wallet)
    transfers.define(code: :spend, from: :wallet, to: :revenue)
    transfers.define(code: :refund, from: :revenue, to: :wallet)
  end
end
