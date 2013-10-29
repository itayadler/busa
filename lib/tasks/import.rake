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

  task :shape_path => :environment do
    all_time = Benchmark.realtime { 
      shapes = ActiveRecord::Base.connection.execute("select * from shapes")
      puts "Importing #{shapes.count} points"
      factory = RGeo::Cartesian.factory(srid: 4326)
      models = []
      grouped_shapes = nil
      grouping_time = Benchmark.realtime { grouped_shapes = shapes.group_by { |shape| shape["id"] } }
      puts "grouping shapes took #{grouping_time/60} minutes"
      puts "Importing #{grouped_shapes.count} paths"
      i = 1
      grouped_shapes.map do |shape_id, shapes|
        points = shapes.sort { |a,b| a["shape_pt_sequence"] <=> b["shape_pt_sequence"] }.map { |shape| factory.point(shape["shape_pt_lon"], shape["shape_pt_lat"]) }
        path = factory.line_string(points)
        model = Path.new(shape_id: shape_id, path: path)
        models << model
        print "\rCreated shape #{i}"
        i += 1
      end
      puts "Importing shapes to database"
      Path.import(models)
    }
    puts "Finished importing in #{all_time/60} minutes"
  end
end
