class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.datetime :datetime
      t.float :temp
      t.float :lowTemp
      t.float :highTemo
      t.float :rainFall
      t.string :windDir
      t.string :windSpd

      t.timestamps null: false
    end
  end
end
