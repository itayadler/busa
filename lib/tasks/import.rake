require 'benchmark'

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
end
