class SpendsController < ApplicationController
  def create
    wallet = Wallet.where(ref: params[:wallet]).first_or_create!
    revenue = Revenue.where(ref: params[:revenue]).first_or_create!
    wallet.spend revenue, params[:amount], params[:ref], params[:data]
    render json: {}
  end
end
