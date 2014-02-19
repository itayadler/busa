class RemoveHebrewCityFromStopCities < ActiveRecord::Migration
  def up
    remove_column :stop_cities, :city_hebrew
  end

  def down
    change_table :stop_cities do |t|
      t.string :city_hebrew
    end
  end
end
