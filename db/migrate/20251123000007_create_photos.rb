class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :model_set, null: false, foreign_key: true
      t.integer :photo_type, null: false, default: 0
      t.integer :position, default: 0, null: false
      t.text :notes
      t.date :taken_at
      t.boolean :primary, default: false, null: false

      t.timestamps
    end

    add_index :photos, :photo_type
    add_index :photos, [:model_set_id, :position]
    add_index :photos, [:model_set_id, :primary]
  end
end