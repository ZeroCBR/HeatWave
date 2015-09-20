# Create user table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :f_name, null: false
      t.string :l_name, null: false
      t.string :password, null: false
      t.boolean :admin_access
      t.string :gender, null: false
      t.string :address, null: false
      t.string :phone
      t.integer :age, null: false
      t.string :email
      t.boolean :suscribed
      t.date :birthday, null: false
      t.integer :postcode, null: false

      t.timestamps null: false
    end
  end
end
