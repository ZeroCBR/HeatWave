# Create user table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :f_name, null: false
      t.string :l_name, null: false
      t.boolean :admin_access, null: false, default: false
      t.string :gender, null: false
      t.string :phone
      t.integer :age, null: false
      t.string :message_type # 'phone', 'email', or NULL
      t.integer :location_id, null: false

      t.timestamps null: false
    end
  end
end
