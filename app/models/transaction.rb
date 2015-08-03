class Transaction < ActiveRecord::Base
  def self.perform from, to, amount, ref, data={}
    from_account = from.ledger_account
    to_account = to.ledger_account

    DoubleEntry.lock_accounts(from_account, to_account) do
      self.transaction do # This starts a database transaction, unrelated to this class
        transaction = self.where(ref: ref).first
        return unless transaction.nil? # a transaction with this ref has already been created. Exit.

        transaction = self.create ref: ref, data: data

        DoubleEntry.transfer Money.new(amount),
                from: from_account,
                to: to_account,
                detail: transaction,
                code: self.name.downcase.to_sym # DoubleEntry will make sure only the registered subclasses are used
      end
    end
    self.where(ref: ref).first
  end
end
