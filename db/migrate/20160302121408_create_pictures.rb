class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :medium_id, index: true
      t.attachment :image

      t.timestamps null: false
    end
  end
end
