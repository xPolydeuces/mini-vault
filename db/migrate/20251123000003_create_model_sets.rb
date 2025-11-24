class CreateModelSets < ActiveRecord::Migration[8.1]
  def change
    create_table :model_sets do |t|
      t.references :series, null: false, foreign_key: true
      t.references :faction, foreign_key: true
      t.references :parent, foreign_key: { to_table: :model_sets }
      t.references :user, foreign_key: true, null: true

      t.string :name, null: false

      # Model counts
      t.integer :total_models, null: false
      t.integer :on_sprue, default: 0, null: false
      t.integer :in_assembly, default: 0, null: false
      t.integer :assembled, default: 0, null: false
      t.integer :in_painting, default: 0, null: false
      t.integer :painted, default: 0, null: false

      # Additional info
      t.string :storage_location
      t.text :paint_scheme_notes
      t.date :purchase_date

      # Status tracking
      t.integer :status, default: 0, null: false
      t.integer :priority, default: 0, null: false

      # Archival tracking
      t.boolean :archived, default: false, null: false
      t.string :archived_reason
      t.datetime :archived_at

      t.timestamps
    end

    add_index :model_sets, :status
    add_index :model_sets, :priority
    add_index :model_sets, [:series_id, :status]
    add_index :model_sets, :archived
    add_index :model_sets, [:archived, :archived_reason]
  end
end