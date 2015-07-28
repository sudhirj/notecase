class AccountsController < ApplicationController
    def create
      account = model.where(ref: params[:ref]).first_or_create
      account.update_attributes data: params[:data]

    end

    def model
      raise "Needs to be subclassed"
    end
end
