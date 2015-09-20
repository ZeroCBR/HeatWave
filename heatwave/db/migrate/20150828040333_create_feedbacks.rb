# Create feedback table
class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.string :content, null: false
      t.string :comment
      t.boolean :responded

      t.timestamps null: false
    end
  end
end
