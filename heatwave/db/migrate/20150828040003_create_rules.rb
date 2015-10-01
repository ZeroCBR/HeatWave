# Create rule table
class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.boolean :activated, default: false

      t.integer :delta, limit: 1, null: false
      t.integer :duration, limit: 1, null: false

      t.timestamps null: false
    end
  end
end
