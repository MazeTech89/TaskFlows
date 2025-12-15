class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  
  # Statistics methods
  def completion_rate
    return 0 if tasks.count.zero?
    (tasks.completed.count.to_f / tasks.count * 100).round(2)
  end
  
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
