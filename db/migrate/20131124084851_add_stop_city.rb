class AddStopCity < ActiveRecord::Migration
  def change
    create_table :stop_cities do |t|
      t.references :stop, index: true
      t.string :city
      t.string :address
    end
  end
end
