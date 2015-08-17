class RefundsController < ApplicationController
  def create
    Spend.where(ref: params[:ref]).first.refund
    render json: {}
  end
end
