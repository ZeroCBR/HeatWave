# Create attribute rule join table
class CreateAttributesRules < ActiveRecord::Migration
  def change
    create_table :attributes_rules do |t|
      t.integer :attribute_id, null: false
      t.integer :rule_id, null: false

      t.timestamps null: false
    end
  end
end
