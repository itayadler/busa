class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :code
      t.string :name
      t.string :description
      t.float :lat 
      t.float :lon 
      t.integer :location_type
      t.string :parent_station
    end
  end
end
