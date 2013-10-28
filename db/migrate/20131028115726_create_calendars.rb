class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars, id: false do |t|
      t.integer :service_id
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.date :start_date
      t.date :end_date
    end
  end
end
