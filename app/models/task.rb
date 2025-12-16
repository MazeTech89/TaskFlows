# Task model - represents individual tasks within projects
require "taskflows_utils"

class Task < ApplicationRecord
  # Task belongs to a project (required) and optionally has a priority
  belongs_to :project
  belongs_to :priority, optional: true

  validates :name, presence: true

  # Scopes for common queries
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :overdue, -> { where("due_date < ? AND completed = ?", Date.today, false) }
  scope :due_today, -> { where(due_date: Date.today) }
  scope :by_project, ->(project_id) { where(project_id: project_id) if project_id.present? }
  scope :by_priority, ->(priority_id) { where(priority_id: priority_id) if priority_id.present? }
  scope :by_completion_status, ->(status) {
    return all if status.blank?
    status == "completed" ? completed : pending
  }
  # Order tasks by calculated priority score (highest first)
  scope :by_priority_score, -> {
    all.sort_by { |task| -task.calculate_priority_score }
  }

  # Check if task is past due date and not completed
  def overdue?
    due_date.present? && due_date < Date.today && !completed?
  end

  # Return human-readable status
  def status
    return "Overdue" if overdue?
    completed? ? "Completed" : "Pending"
  end

  # Calculate dynamic priority score using taskflows_utils gem
  # @param importance_override [Numeric, nil] override importance (uses priority.score if nil)
  # @param effort_override [Numeric, nil] override effort hours (defaults to 2 if nil)
  # @return [Numeric] calculated priority score
  def calculate_priority_score(importance_override: nil, effort_override: nil)
    scorer = TaskflowsUtils::PriorityScoring.new

    # Use priority's importance if available, otherwise default to 3
    importance = importance_override || priority&.score || 3.0

    # Default effort to 2 hours if not provided
    effort = effort_override || 2.0

    scorer.score(
      deadline: due_date,
      importance: importance,
      effort_hours: effort,
      current_date: Date.today
    )
  end
end
