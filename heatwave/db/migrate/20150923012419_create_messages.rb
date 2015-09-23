class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      # Triggered by:
      t.integer :weather_id, null: false
      t.integer :rule_id, null: false

      # Message details:
      t.integer :user_id, null: false
      t.datetime :send_time # Can be null if not sent.
      t.string :contents, null: false

      t.timestamps null: false
    end

    add_foreign_key :messages, :weathers
    add_foreign_key :messages, :weathers

    add_foreign_key :messages, :users
  end
end
