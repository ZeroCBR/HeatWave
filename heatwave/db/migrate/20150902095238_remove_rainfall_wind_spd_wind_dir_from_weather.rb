class RemoveRainfallWindSpdWindDirFromWeather < ActiveRecord::Migration
  def change
    remove_column :weathers, :rainFall, :float
    remove_column :weathers, :windSpd, :string
    remove_column :weathers, :windDir, :string
  end
end
