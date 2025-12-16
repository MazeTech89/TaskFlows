# Migration: creates priorities table with name field and unique index
class CreatePriorities < ActiveRecord::Migration[8.1]
  def change
    create_table :priorities do |t|
      t.string :name, null: false  # Priority name (required)
      t.timestamps                  # created_at, updated_at
    end

    # Index for faster lookups and enforces uniqueness at DB level
    add_index :priorities, :name, unique: true
  end
end
