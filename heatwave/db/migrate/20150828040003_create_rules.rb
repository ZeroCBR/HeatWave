# Create rule table
class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.string :annotation

      t.timestamps null: false
    end
  end
end
