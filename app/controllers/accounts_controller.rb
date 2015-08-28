class AccountsController < ApplicationController
    def create
      account = model.where(ref: params[:ref]).first_or_create!
      account.update_attributes! data: params[:data]
    end

    def show
      account = model.where(ref: params[:id]).first_or_create!
      render json: {
        ref: account.ref,
        balance: account.balance,
        data: account.data
      }
    end

    def model
      raise "Needs to be subclassed"
    end
end
