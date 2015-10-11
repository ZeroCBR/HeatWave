class AddMessageTypeToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :message_type, :string
    add_column :messages, :sent_to, :string
  end

  def self.down
    remove_column :messages, :message_type, :string
    remove_column :messages, :sent_to, :string
  end
end
