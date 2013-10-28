class AddIndexes < ActiveRecord::Migration
  def change
    add_index :stop_times, :trip_id
    add_index :stop_times, :stop_id
    add_index :trips, :id
    add_index :trips, :service_id
    add_index :trips, :route_id
    add_index :calendars, :service_id
  end
end
