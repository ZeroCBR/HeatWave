class CreateUsersAttributes < ActiveRecord::Migration
  def change
    create_table :users_attributes do |t|
      t.integer :user_id, null: false
      t.integer :attribute_id, null: false

      t.timestamps null: false
    end
  end
end
