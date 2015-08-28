class Spend < Transaction
  def refund data={}
    line = DoubleEntry::Line.where(detail: self).first
    wallet = Wallet.where(id: line.scope).first
    revenue = Revenue.where(id: line.partner_scope).first
    Refund.perform revenue, wallet, line.amount.abs, "#{self.ref}.refund", data
  end
end
