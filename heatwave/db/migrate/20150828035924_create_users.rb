class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :f_name
      t.string :l_name
      t.string :password
      t.boolean :adminAccess
      t.string :gender
      t.string :address
      t.string :phone
      t.integer :age
      t.string :email
      t.boolean :suscribed
      t.date :birthday
      t.integer :postcode

      t.timestamps null: false
    end
  end
end
