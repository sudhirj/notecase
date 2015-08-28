class Account < ActiveRecord::Base
  validates_presence_of :ref

  def balance
    ledger_account.balance.fractional
  end

  def ledger_account
    DoubleEntry.account(self.class.name.downcase.to_sym, scope: self.id)
  end



end
