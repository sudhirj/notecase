class AddDoubleEntryLineMetadata < ActiveRecord::Migration
  def self.up
    create_table "#{DoubleEntry.table_name_prefix}line_metadata", :force => true do |t|
      t.integer    "line_id",               :null => false
      t.string     "key",     :limit => 48, :null => false
      t.string     "value",   :limit => 64, :null => false
      t.timestamps                          :null => false
    end

    add_index "#{DoubleEntry.table_name_prefix}line_metadata",
              ["line_id", "key", "value"],
              :name => "lines_meta_line_id_key_value_idx"
  end

  def self.down
    drop_table "#{DoubleEntry.table_name_prefix}line_metadata"
  end
end
