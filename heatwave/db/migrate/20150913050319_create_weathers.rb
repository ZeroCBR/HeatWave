class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.integer :location_id, null: false
      t.integer :high_temp, null: false, limit: 1
      t.date :date, null: false

      t.timestamps null: false
    end

    add_foreign_key :weathers, :locations
  end
end
