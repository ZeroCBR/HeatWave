class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.decimal :jan_mean, precision: 4, scale: 1, null: false
      t.decimal :feb_mean, precision: 4, scale: 1, null: false
      t.decimal :mar_mean, precision: 4, scale: 1, null: false
      t.decimal :apr_mean, precision: 4, scale: 1, null: false
      t.decimal :may_mean, precision: 4, scale: 1, null: false
      t.decimal :jun_mean, precision: 4, scale: 1, null: false
      t.decimal :jul_mean, precision: 4, scale: 1, null: false
      t.decimal :aug_mean, precision: 4, scale: 1, null: false
      t.decimal :sep_mean, precision: 4, scale: 1, null: false
      t.decimal :oct_mean, precision: 4, scale: 1, null: false
      t.decimal :nov_mean, precision: 4, scale: 1, null: false
      t.decimal :dec_mean, precision: 4, scale: 1, null: false

      t.timestamps null: false
    end

    add_foreign_key :users, :locations
  end
end
