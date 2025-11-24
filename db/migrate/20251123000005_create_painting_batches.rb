class CreatePaintingBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :painting_batches do |t|
      t.string :batch_number, null: false
      t.text :notes
      t.date :started_at
      t.date :completed_at

      t.timestamps
    end

    create_table :painting_batch_model_sets do |t|
      t.references :painting_batch, null: false, foreign_key: true
      t.references :model_set, null: false, foreign_key: true

      t.timestamps
    end

    add_index :painting_batch_model_sets,
              [:painting_batch_id, :model_set_id],
              unique: true,
              name: 'index_batch_models_unique'
  end
end