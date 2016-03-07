class ChangeIdsToBigint < ActiveRecord::Migration
  def change
    change_column :double_entry_lines, :id, :bigint
    change_column :double_entry_lines, :partner_id, :bigint
    change_column :double_entry_lines, :detail_id, :bigint

    change_column :double_entry_line_aggregates, :id, :bigint

    change_column :double_entry_line_checks, :id, :bigint
    change_column :double_entry_line_checks, :last_line_id, :bigint

    change_column :transactions, :id, :bigint

    change_column :accounts, :id, :bigint

    change_column :double_entry_account_balances, :id, :bigint

    change_column :double_entry_line_metadata, :id, :bigint
    change_column :double_entry_line_metadata, :line_id, :bigint
  end
end
