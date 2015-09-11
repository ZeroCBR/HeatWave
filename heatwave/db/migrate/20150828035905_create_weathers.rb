# Create weather table
class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.datetime :datetime
      t.float :temp
      t.float :low_temp
      t.float :high_temp

      t.timestamps null: false
    end
  end
end
