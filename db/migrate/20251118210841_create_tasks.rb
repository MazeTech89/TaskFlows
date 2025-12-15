class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.references :project, null: false, foreign_key: true
      t.references :priority, foreign_key: true
      t.date :due_date
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
