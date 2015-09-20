# Create rule table
class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.string :annotation, null: false

      t.timestamps null: false
    end
  end
end
