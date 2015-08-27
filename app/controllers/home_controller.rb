class HomeController < ApplicationController
  def index
    render json: {
      wallets: Wallet.count,
      liabilities: (DoubleEntry::AccountBalance.where(account: "wallet").first.balance.to_s rescue 0)
    }
  end
end
