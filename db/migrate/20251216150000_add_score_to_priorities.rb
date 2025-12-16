# Migration: adds score field to priorities table for importance rating
class AddScoreToPriorities < ActiveRecord::Migration[8.1]
  def change
    # Check if column exists before adding to avoid duplicate column error
    unless column_exists?(:priorities, :score)
      add_column :priorities, :score, :decimal, precision: 5, scale: 2, default: 3.0
    end
  end
end
