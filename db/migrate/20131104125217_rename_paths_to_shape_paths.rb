class RenamePathsToShapePaths < ActiveRecord::Migration
  def change
    rename_table :paths, :shape_paths
  end
end
