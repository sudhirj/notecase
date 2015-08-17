class RechargesController < TransactionsController
  def create
    wallet = Wallet.where(ref: params[:wallet]).first_or_create!
    recharger = Recharger.where(ref: params[:recharger]).first_or_create!
    recharger.recharge wallet, params[:amount], params[:ref], params[:data]
    render json: {}
  end
end
