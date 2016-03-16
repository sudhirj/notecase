require 'double_entry'

Money.default_currency = Money::Currency.new(ENV["DEFAULT_CURRENCY"] || "INR")

DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    wallet_positive_values_only = true
    overdraft = ENV["OVERDRAFT"].to_s.downcase
    if overdraft == "true" || overdraft == "1" || overdraft == "yes"
      wallet_positive_values_only = false
    end
    accounts.define(identifier: :wallet, scope_identifier: accounts.active_record_scope_identifier(Wallet), positive_only: wallet_positive_values_only)
    accounts.define(identifier: :recharger, scope_identifier: accounts.active_record_scope_identifier(Recharger))
    accounts.define(identifier: :revenue, scope_identifier: accounts.active_record_scope_identifier(Revenue), positive_only: true)
  end

  config.define_transfers do |transfers|
    transfers.define(from: :recharger, to: :wallet, code: :recharge)
    transfers.define(from: :wallet, to: :revenue, code: :spend)
    transfers.define(from: :revenue, to: :wallet, code: :refund)
  end
end
