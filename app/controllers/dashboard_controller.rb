class DashboardController < ApplicationController
  def index
    @user = current_user
    @projects = current_user.projects.includes(:tasks)
    @recent_projects = @projects.recent.limit(5)
    
    # Task statistics
    @total_tasks = current_user.tasks.count
    @completed_tasks = current_user.tasks.completed.count
    @pending_tasks = current_user.tasks.pending.count
    @overdue_tasks = current_user.tasks.overdue.count
    
    # Overall completion rate
    @completion_rate = @total_tasks > 0 ? (@completed_tasks.to_f / @total_tasks * 100).round(2) : 0
    
    # Tasks by project for chart
    @tasks_by_project = current_user.projects
                                    .joins(:tasks)
                                    .group('projects.name')
                                    .count
    
    # Task completion trend (last 7 days)
    @completion_trend = current_user.tasks
                                     .completed
                                     .where('tasks.updated_at >= ?', 7.days.ago)
                                     .group_by_day(:updated_at)
                                     .count
    
    # Tasks by priority
    @tasks_by_priority = current_user.tasks
                                      .joins(:priority)
                                      .group('priorities.name')
                                      .count
    
    # Recent tasks
    @recent_tasks = current_user.tasks
                                 .includes(:project, :priority)
                                 .order(created_at: :desc)
                                 .limit(10)
  end
end
