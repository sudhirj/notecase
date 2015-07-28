class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :type
      t.string :ref, null: false
      t.jsonb :data
      t.timestamps null: false
    end
    add_index :accounts, [:ref], unique: true
  end
end
