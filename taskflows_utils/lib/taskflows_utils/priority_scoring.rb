require 'date'

module TaskflowsUtils
  # Priority scoring algorithm - calculates task priority based on deadline, importance, and effort
  # Higher scores = higher priority; nearer deadlines and overdue tasks boost score
  class PriorityScoring
    # Calculate priority score for a task
    # @param deadline [Date, nil] task due date (nil = far future)
    # @param importance [Numeric] importance rating (1-5 typical scale)
    # @param effort_hours [Numeric] estimated hours to complete
    # @return [Numeric] calculated priority score
    def score(deadline:, importance:, effort_hours:)
      importance = (importance || 0).to_f
      effort = (effort_hours || 0).to_f

      # Calculate days until deadline (365 if no deadline)
      days = if deadline.nil?
               365.0
             else
               (deadline - Date.today).to_i.to_f
             end

      # Time multiplier: closer deadlines = higher multiplier
      time_multiplier = if days <= 0
                          # Overdue: large multiplier that grows with lateness
                          2.0 + ([-days, 0].max / 7.0)
                        else
                          # Upcoming: add 0.0-1.0 based on proximity (within 30 days)
                          add = (30.0 - days) / 30.0
                          add = 0.0 if add < 0.0
                          add = 1.0 if add > 1.0
                          1.0 + add
                        end

      base = importance * 10.0
      effort_penalty = effort * 1.5  # Higher effort = lower priority

      score = base * time_multiplier - effort_penalty

      # Strong boost for overdue tasks to ensure they're at top of list
      score += 200 if deadline && deadline < Date.today

      score
    end
  end
end
