class CreateFactions < ActiveRecord::Migration[8.1]
  def change
    create_table :factions do |t|
      t.references :series, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :model_sets_count, default: 0, null: false

      t.timestamps
    end

    add_index :factions, [:series_id, :name], unique: true
  end
end