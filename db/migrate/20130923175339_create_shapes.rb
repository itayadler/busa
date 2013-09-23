class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.float :shape_pt_lat
      t.float :shape_pt_lon
      t.integer :shape_pt_sequence
    end
  end
end
