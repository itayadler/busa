class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.references :shape, index: true
      t.line_string :path, srid: 4326
    end
  end
end
