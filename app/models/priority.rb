class Priority < ApplicationRecord
  has_many :tasks
  validates :name, presence: true, uniqueness: true
end
