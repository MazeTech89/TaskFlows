# Task model - represents individual tasks within projects
class Task < ApplicationRecord
  # Task belongs to a project (required) and optionally has a priority
  belongs_to :project
  belongs_to :priority, optional: true
  
  validates :name, presence: true
  
  # Scopes for common queries
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :overdue, -> { where('due_date < ? AND completed = ?', Date.today, false) }
  scope :due_today, -> { where(due_date: Date.today) }
  scope :by_project, ->(project_id) { where(project_id: project_id) if project_id.present? }
  scope :by_priority, ->(priority_id) { where(priority_id: priority_id) if priority_id.present? }
  scope :by_completion_status, ->(status) { 
    return all if status.blank?
    status == 'completed' ? completed : pending 
  }
  
  # Check if task is past due date and not completed
  def overdue?
    due_date.present? && due_date < Date.today && !completed?
  end
  
  # Return human-readable status
  def status
    return 'Overdue' if overdue?
    completed? ? 'Completed' : 'Pending'
  end
end
