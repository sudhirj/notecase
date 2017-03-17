require 'double_entry'

Money.default_currency = Money::Currency.new(ENV["DEFAULT_CURRENCY"] || "INR")

DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    allow_overdraft = ENV.fetch('ALLOW_OVERDRAFT', 0).to_i
    accounts.define(identifier: :wallet, scope_identifier: accounts.active_record_scope_identifier(Wallet), positive_only: allow_overdraft.zero?)
    accounts.define(identifier: :recharger, scope_identifier: accounts.active_record_scope_identifier(Recharger))
    accounts.define(identifier: :revenue, scope_identifier: accounts.active_record_scope_identifier(Revenue), positive_only: true)
  end

  config.define_transfers do |transfers|
    transfers.define(from: :recharger, to: :wallet, code: :recharge)
    transfers.define(from: :wallet, to: :revenue, code: :spend)
    transfers.define(from: :revenue, to: :wallet, code: :refund)
  end
end
