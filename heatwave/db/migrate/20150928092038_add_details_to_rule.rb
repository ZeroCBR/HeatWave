class AddDetailsToRule < ActiveRecord::Migration
  def self.up
    add_column :rules, :key_advice, :text
    change_column :rules, :key_advice, :text, :null => false
    add_column :rules, :full_advice, :text
    change_column :rules, :full_advice, :text, :null => false
  end

  def self.down
    remove_column :rules, :key_advice
    remove_column :rules, :full_advice
  end
end
