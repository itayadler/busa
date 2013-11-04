class AddIndexToStopPaths < ActiveRecord::Migration
  def change
    change_table :stop_paths do |t|
      t.index :points, spatial: true
    end
  end
end
