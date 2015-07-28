class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type
      t.string :ref, null: false
      t.jsonb :data
      t.timestamps null: false
    end
    add_index :transactions, [:ref], unique: true
  end
end
