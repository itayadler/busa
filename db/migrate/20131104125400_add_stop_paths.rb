class AddStopPaths < ActiveRecord::Migration
  def change
    create_table :stop_paths do |t|
      t.string :trip_id, index: true
      t.multi_point :points, srid: 4326, geographic: true
    end
  end
end
