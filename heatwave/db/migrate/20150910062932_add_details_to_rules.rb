class AddDetailsToRules < ActiveRecord::Migration
  def change
    add_column :rules, :delta, :string
    add_column :rules, :duration, :datetime
  end
end
