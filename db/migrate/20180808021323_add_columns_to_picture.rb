class AddColumnsToPicture < ActiveRecord::Migration[5.1]
  def change
    add_column :pictures, :exif, :string
    add_column :pictures, :lat, :string
    add_column :pictures, :long, :string
  end
end
