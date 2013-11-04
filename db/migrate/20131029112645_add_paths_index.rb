class AddPathsIndex < ActiveRecord::Migration
  def change
    change_table :shape_paths do |t|
      t.index :path, spatial: true
    end
  end
end
