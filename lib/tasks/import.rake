require 'benchmark'
require 'net/ftp'
require 'fileutils'
require 'rgeo'

namespace :import do
  ISRAEL_BUS_GTFS_HOST = 'gtfs.mot.gov.il'
  ISRAEL_BUS_GTFS_PATH = '/israel-public-transportation.zip'

  def download_file_from_ftp(host, path, save_path)
    ftp = Net::FTP.new(host)
    ftp.login
    ftp.getbinaryfile(path, save_path)
  end

  desc 'import new gtfs'
  task :all => [:environment, :download_gtfs, :gtfs, :shape_path, :stop_cities, :stop_path] do
    emails = ["itayadler@gmail.com", "giladgo@gmail.com"]
    emails.each do |email_addr|
      ActionMailer::Base.mail(:from => "no-reply@busa.kata-log.com", :to => email_addr, :subject => "Busa - GTFS daily import", :body => "The import has finished successfully").deliver
    end
  end

  desc 'Download GTFS from mot FTP'
  task :download_gtfs => [:environment] do
    gtfs_download_path = "#{Rails.root}/gtfs.zip"
    gtfs_path = "#{Rails.root}/gtfs"

    puts 'Removing GTFS zip'
    FileUtils.remove_file(gtfs_download_path) if File.exists?(gtfs_download_path)
    puts 'Downloading GTFS'
    download_file_from_ftp(ISRAEL_BUS_GTFS_HOST, ISRAEL_BUS_GTFS_PATH, gtfs_download_path)
    puts 'Finished downloading GTFS'

    puts 'Deleting GTFS path'
    FileUtils.rm_rf(gtfs_path)
    puts 'Creating GTFS path'
    FileUtils.mkdir(gtfs_path)
    puts 'Unzipping gtfs.zip into gtfs path'
    %x(unzip #{gtfs_download_path} -d gtfs)
    puts 'Done!'
  end

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
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{ShapePath.table_name}"
    time = Benchmark.realtime do
      sql = %{
        INSERT INTO #{ShapePath.table_name} (shape_id, path) 
          (
            SELECT id, ST_GeomFromText('LINESTRING(' || string_agg(shape_pt_lon || ' ' || shape_pt_lat, ',' order by shape_pt_sequence) || ')', 4326) 
            FROM shapes 
            GROUP BY id
          )
      }
      ActiveRecord::Base.connection.execute(sql)
    end
    puts "This awesome import took #{time} seconds"
  end

  desc "Creating for the trips that miss a shape_id a StopPath"
  task :stop_path => :environment do
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{StopPath.table_name}"
    time = Benchmark.realtime do
      sql = %{
        INSERT INTO #{StopPath.table_name} (trip_id, points) 
          (
            SELECT trips.id, ST_GeomFromText('MULTIPOINT(' || string_agg(lon || ' ' || lat, ',' order by stop_sequence) || ')', 4326) 
            FROM trips
            INNER JOIN stop_times ON stop_times.trip_id = trips.id 
            INNER JOIN stops ON stops.id = stop_times.stop_id 
            WHERE trips.shape_id is NULL
            GROUP BY trips.id
          )
      }
      ActiveRecord::Base.connection.execute(sql)
    end
    puts "This awesome import took #{time} seconds"
  end

  desc "Filling the stop_cities table with data"
  task :stop_cities => :environment do
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{StopCity.table_name}"
    sql = <<-SQL
      COPY #{StopCity.table_name} 
      FROM '#{Rails.root}/payload/stop_cities.csv'
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
