class CreateSeries < ActiveRecord::Migration[8.1]
  def change
    create_table :series do |t|
      t.string :name, null: false
      t.integer :model_sets_count, default: 0, null: false

      t.timestamps
    end

    add_index :series, :name, unique: true
  end
end