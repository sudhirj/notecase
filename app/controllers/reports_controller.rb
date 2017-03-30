require 'date'

class ReportsController < ApplicationController
  def statement
    wallet_id = params[:wallet_id]
    limit = params[:count]
    offset = params[:offset] || 0
    wallet = Account.find_by(:ref => wallet_id)
    to_date = params[:to_date] ? Date.parse(params[:to_date]).to_time : DateTime.now
    from_date = params[:from_date] ? Date.parse(params[:from_date]).to_time : to_date - 30

    if (from_date > to_date)
      render json: 'From date is after to date', status: 400
      return
    end

    if wallet.nil?
      render json: '', status: 404
      return
    end

    from_date_start_of_day = DateTime.new(from_date.year, from_date.month, from_date.day, 0, 0, 0, from_date.zone).to_s
    to_date_end_of_day =DateTime.new(to_date.year, to_date.month, to_date.day, 23, 59, 59, to_date.zone).to_s


    transactions = Transaction
                       .joins("INNER join double_entry_lines del on transactions.id = del.detail_id")
                       .offset(offset)
                       .where('del.scope = :scope', :scope => wallet.id.to_s)
                       .where('transactions.created_at >= :from_date AND transactions.created_at <= :to_date', {:from_date => from_date_start_of_day, :to_date => to_date_end_of_day})
                       .select("transactions.*, del.account, del.scope, del.code, del.amount, del.balance")

    transactions = transactions.limit(limit) unless limit.nil?                   


    render json: transactions.to_json

  end
end
