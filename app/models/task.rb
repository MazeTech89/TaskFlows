class Task < ApplicationRecord
  belongs_to :project
  belongs_to :priority, optional: true
  validates :name, presence: true
end
