class AddIndexOnTripsShapeId < ActiveRecord::Migration
  def change
    add_index :trips, :shape_id
  end
end
