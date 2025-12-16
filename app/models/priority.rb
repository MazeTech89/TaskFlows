# Priority model - represents task priority levels (High, Medium, Low, etc.)
class Priority < ApplicationRecord
  # One priority can be assigned to many tasks
  has_many :tasks
  
  # Name must exist and be unique (e.g., no duplicate "High" priorities)
  validates :name, presence: true, uniqueness: true
  # Score represents importance rating (1-5 scale typical)
  validates :score, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
