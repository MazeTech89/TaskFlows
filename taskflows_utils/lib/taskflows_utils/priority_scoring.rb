require 'date'

module TaskflowsUtils
  # Priority scoring algorithm - calculates task priority based on deadline, importance, and effort
  # Higher scores = higher priority; nearer deadlines and overdue tasks boost score
  class PriorityScoring
    # Configuration constants
    IMPORTANCE_MULTIPLIER = 10.0
    EFFORT_PENALTY_RATE = 1.5
    OVERDUE_BASE_MULTIPLIER = 2.0
    OVERDUE_BOOST = 200.0
    LATENESS_SCALE_DAYS = 7.0
    PROXIMITY_WINDOW_DAYS = 30.0
    NO_DEADLINE_DEFAULT_DAYS = 365.0

    # Calculate priority score for a task
    # @param deadline [Date, nil] task due date (nil = far future)
    # @param importance [Numeric] importance rating (1-5 typical scale)
    # @param effort_hours [Numeric] estimated hours to complete
    # @param current_date [Date] current date for testing (defaults to today)
    # @return [Numeric] calculated priority score
    def score(deadline:, importance:, effort_hours:, current_date: Date.today)
      # Validate deadline is a Date if provided
      unless deadline.nil? || deadline.is_a?(Date)
        raise ArgumentError, "deadline must be a Date or nil, got #{deadline.class}"
      end

      importance = (importance || 0).to_f
      effort = (effort_hours || 0).to_f

      # Calculate days until deadline (365 if no deadline)
      days = if deadline.nil?
               NO_DEADLINE_DEFAULT_DAYS
      else
               (deadline - current_date).to_i.to_f
      end

      # Time multiplier: closer deadlines = higher multiplier
      time_multiplier = if days <= 0
                          # Overdue: large multiplier that grows with lateness
                          # Fixed bug: use days.abs instead of [-days, 0].max
                          OVERDUE_BASE_MULTIPLIER + (days.abs / LATENESS_SCALE_DAYS)
      else
                          # Upcoming: add 0.0-1.0 based on proximity (within 30 days)
                          add = (PROXIMITY_WINDOW_DAYS - days) / PROXIMITY_WINDOW_DAYS
                          add = [ [ add, 0.0 ].max, 1.0 ].min  # Clamp between 0 and 1
                          1.0 + add
      end

      base = importance * IMPORTANCE_MULTIPLIER
      effort_penalty = effort * EFFORT_PENALTY_RATE

      score = base * time_multiplier - effort_penalty

      # Strong boost for overdue tasks to ensure they're at top of list
      score += OVERDUE_BOOST if deadline && deadline < current_date

      score
    end
  end
end
