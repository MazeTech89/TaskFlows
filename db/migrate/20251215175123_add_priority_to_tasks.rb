class AddPriorityToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :priority, null: true, foreign_key: true
  end
end
