# Create attribute table
class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :name, null: false
      t.string :annotation, null: false

      t.timestamps null: false
    end
  end
end
