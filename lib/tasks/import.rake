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
    Dir.foreach(gtfs_folder_path) do |file|
      klass_name = File.basename(file, '.txt')
      active_model = klass_name.camelcase.singularize.safe_constantize
      copy_into_table(active_model, "#{gtfs_folder_path}/#{file}") if active_model.present?
    end
  end
end
