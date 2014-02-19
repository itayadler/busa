class CreateCitiesTable < ActiveRecord::Migration
  def up
    create_table :cities do |t|
      t.string :name
      t.geometry :location
    end

    change_table :cities do |t|
      t.index :location, :spatial => true
    end
  end

  def down
    drop_table :cities
  end
end
