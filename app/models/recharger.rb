class Recharger < Account
  def recharge wallet, amount, ref, data={}
    Recharge.perform(self, wallet, amount, ref, data)
  end
end
