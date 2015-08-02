class Transaction < ActiveRecord::Base
  def self.perform from, to, amount, ref, data
    from_account = from.ledger_account
    to_account = to.ledger_account

    DoubleEntry.lock_accounts(from_account, to_account) do
      self.transaction do
        transaction = self.where(ref: ref).first
        return unless transaction.nil?

        self.create ref: ref, data: data

        DoubleEntry.transfer Money.new(amount),
                from: from_account,
                to: to_account,
                detail: transaction,
                code: self.name.downcase.to_sym
      end
    end
  end
end
