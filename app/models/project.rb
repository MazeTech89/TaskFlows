# Project model - user's collection of tasks
class Project < ApplicationRecord
  # Project belongs to a user and contains many tasks
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # Name required (3-100 chars), description optional (max 500 chars)
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  # Order by newest first
  scope :recent, -> { order(created_at: :desc) }

  # Calculate percentage of completed tasks
  def completion_rate
    return 0 if tasks.count.zero?
    (tasks.completed.count.to_f / tasks.count * 100).round(2)
  end

  # Task count helpers
  def tasks_count
    tasks.count
  end

  def completed_tasks_count
    tasks.completed.count
  end

  def pending_tasks_count
    tasks.pending.count
  end
end
