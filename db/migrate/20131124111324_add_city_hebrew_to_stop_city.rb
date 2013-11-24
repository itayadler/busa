class AddCityHebrewToStopCity < ActiveRecord::Migration
  def change
    change_table :stop_cities do |t|
      t.string :city_hebrew
    end
  end
end
