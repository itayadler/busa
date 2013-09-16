class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.string :arrival_time
      t.string :departure_time
      t.string :stop_id
      t.string :stop_sequence
      t.string :pickup_type
      t.string :drop_off_type
    end
  end
end
