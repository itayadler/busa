class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :agency_id, limit: 1
      t.string :route_short_name
      t.string :route_long_name
      t.string :route_desc
      t.integer :route_type, limit: 1
      t.string :route_color
    end
  end
end
