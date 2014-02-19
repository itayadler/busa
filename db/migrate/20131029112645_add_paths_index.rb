class AddPathsIndex < ActiveRecord::Migration
  def change
    change_table :paths do |t|
      t.index :path, spatial: true
    end
  end
end
