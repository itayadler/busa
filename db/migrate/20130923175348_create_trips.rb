class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips, id: false do |t|
      t.references :route
      t.integer :service_id
      t.string :id, unique: true, primary_key: true
      t.integer :direction_id
      t.references :shape
    end
  end
end
