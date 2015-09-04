# Create history table
class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :title
      t.string :content

      t.timestamps null: false
    end
  end
end
