class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times, id: false do |t|
      t.string :trip_id, unique: true
      t.string :arrival_time
      t.string :departure_time
      t.integer :stop_id
      t.integer :stop_sequence
      t.integer :pickup_type, limit: 1
      t.integer :drop_off_type, limit: 1
    end
  end
end
