class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.decimal :jan_average, precision: 4, scale: 1, null: false
      t.decimal :feb_average, precision: 4, scale: 1, null: false
      t.decimal :mar_average, precision: 4, scale: 1, null: false
      t.decimal :apr_average, precision: 4, scale: 1, null: false
      t.decimal :jun_average, precision: 4, scale: 1, null: false
      t.decimal :jul_average, precision: 4, scale: 1, null: false
      t.decimal :aug_average, precision: 4, scale: 1, null: false
      t.decimal :sep_average, precision: 4, scale: 1, null: false
      t.decimal :oct_average, precision: 4, scale: 1, null: false
      t.decimal :nov_average, precision: 4, scale: 1, null: false
      t.decimal :dec_average, precision: 4, scale: 1, null: false

      t.timestamps null: false
    end
  end
end
