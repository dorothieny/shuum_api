class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :tags, :name, :tagname
  end
end
