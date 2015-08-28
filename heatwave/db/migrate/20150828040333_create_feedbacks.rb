class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title
      t.string :content
      t.string :comment
      t.boolean :responded

      t.timestamps null: false
    end
  end
end
