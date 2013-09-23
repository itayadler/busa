class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes, id: false do |t|
      t.integer :id
      t.float :shape_pt_lat
      t.float :shape_pt_lon
      t.integer :shape_pt_sequence
    end
    add_index :shapes, [:id, :shape_pt_sequence]
  end
end
