require 'benchmark'
require 'rgeo'

namespace :import do
  desc 'Import data from GTFS text files'

  def copy_into_table(model, path)
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{model.table_name}"

    sql = <<-SQL
      COPY #{model.table_name} (#{model.columns.map(&:name).join(', ')})
      FROM '#{path}'
      WITH (FORMAT csv, HEADER TRUE)
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  task :gtfs => :environment do
    gtfs_folder_path = "#{Rails.root}/gtfs"
    entire_time = Benchmark.realtime do
      Dir.foreach(gtfs_folder_path) do |file|
        klass_name = File.basename(file, '.txt')
        active_model = klass_name.camelcase.singularize.safe_constantize
        if active_model.present?
          active_model_import_time = Benchmark.realtime do
            copy_into_table(active_model, "#{gtfs_folder_path}/#{file}")
          end
          puts "#{klass_name} import took #{active_model_import_time} seconds"
        end
      end
    end
    puts "Entire import took #{entire_time} seconds"
  end

  desc "Converting the shapes into paths"
  task :shape_path => :environment do
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{Path.table_name}"
    time = Benchmark.realtime do
      sql = %{
        INSERT INTO #{Path.table_name} (shape_id, path) 
          (SELECT id, postgis.ST_GeomFromText('LINESTRING(' || string_agg(shape_pt_lon || ' ' || shape_pt_lat, ',' order by shape_pt_sequence) || ')', 4326) 
            FROM shapes 
            GROUP BY id
          )
      }
      ActiveRecord::Base.connection.execute(sql)
    end
    puts "This awesome import took #{time} seconds"
  end
end
