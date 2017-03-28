class ReportsController < ApplicationController
  def statement
    wallet_id = params[:wallet_id]
    limit = params[:count]
    offset = params[:offset] || 0
    wallet = Account.find_by(:ref => wallet_id)
    to_date = params[:to_date] ? Date.parse(params[:to_date].to_s) : DateTime.now
    from_date = params[:from_date] ? Date.parse(params[:from_date].to_s) : to_date - 30

    if (from_date > to_date)
      render json: 'From date is after to date', status: 400
      return
    end

    if wallet.nil?
      render json: '', status: 404
      return
    end

    transactions = Transaction
                       .joins("INNER join double_entry_lines del on transactions.id = del.detail_id")
                       .offset(offset)
                       .where('del.scope = :scope', :scope => wallet.id.to_s)
                       .where('transactions.created_at > :created_at AND transactions.created_at <= :to_date', {:created_at => from_date, :to_date => to_date})
                       .select("transactions.*, del.account, del.scope, del.code, del.amount, del.balance")

    transactions = transactions.limit(limit) unless limit.nil?                   


    render json: transactions.to_json

  end
end
