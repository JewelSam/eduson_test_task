class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :medium_id, index: true
      t.string :url

      t.timestamps null: false
    end
  end
end
