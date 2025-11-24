class CreateTodoItems < ActiveRecord::Migration[8.1]
  def change
    create_table :todo_items do |t|
      t.references :model_set, foreign_key: true
      t.references :parent, foreign_key: { to_table: :todo_items }

      t.string :title, null: false
      t.text :description
      t.date :due_date
      t.integer :estimated_hours
      t.integer :priority, default: 0, null: false
      t.boolean :completed, default: false, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :todo_items, :completed
    add_index :todo_items, [:due_date, :completed]
  end
end