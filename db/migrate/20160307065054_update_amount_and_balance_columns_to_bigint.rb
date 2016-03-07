class UpdateAmountAndBalanceColumnsToBigint < ActiveRecord::Migration
  def change
    change_column :double_entry_lines, :amount, :bigint
    change_column :double_entry_lines, :balance, :bigint

    change_column :double_entry_account_balances, :balance, :bigint

    change_column :double_entry_line_aggregates, :amount, :bigint
  end
end
