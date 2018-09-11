class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.integer :project_id
      t.string :image

      t.timestamps
    end
  end
end
