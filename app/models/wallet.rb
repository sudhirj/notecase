class Wallet < Account
  def spend revenue, amount, ref, data={}
    Spend.perform(self, revenue, amount, ref, data={})
  end
end
