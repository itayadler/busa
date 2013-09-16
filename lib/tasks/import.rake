namespace :import do
  desc 'Import data from GTFS text files'

  def copy_into_table(model, path)
    sql = <<-SQL
      COPY #{model.table_name} (#{model.columns.map(&:name).join(', ')})
      FROM '#{path}'
      WITH (FORMAT csv, HEADER TRUE)
    SQL
    ActiveRecord::Base.connection.execute sql
  end

  task :gtfs => :environment do
    copy_into_table Agency, "#{Rails.root}/gtfs/agency.txt"
    copy_into_table StopTime, "#{Rails.root}/gtfs/stop_times.txt"
  end
end