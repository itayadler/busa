class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :service_id
      t.references :trip
      t.integer :direction_id
      t.references :shape
    end
  end
end
