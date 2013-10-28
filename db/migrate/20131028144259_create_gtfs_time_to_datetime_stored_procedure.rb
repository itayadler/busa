class CreateGtfsTimeToDatetimeStoredProcedure < ActiveRecord::Migration
  def up
    script_path = "#{Rails.root}/db/migrate/gtfs_time_to_datetime.sql"
    sql_script = File.read(script_path)
    ActiveRecord::Base.connection.execute(sql_script)
  end

  def down
    ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS GTFS_Time_To_DateTime(text, text)")
  end
end
