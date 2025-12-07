require 'date'

module TaskflowsUtils
  # Simple, predictable priority scoring used for tests.
  # The algorithm is intentionally straightforward so tests can express expectations.
  class PriorityScoring
    # @param deadline [Date, nil]
    # @param importance [Numeric]
    # @param effort_hours [Numeric]
    # @return [Numeric]
    def score(deadline:, importance:, effort_hours:)
      importance = (importance || 0).to_f
      effort = (effort_hours || 0).to_f

      days = if deadline.nil?
               365.0
             else
               (deadline - Date.today).to_i.to_f
             end

      # nearer deadlines increase multiplier (closer -> larger multiplier)
      time_multiplier = if days <= 0
                          # overdue: big multiplier that grows with lateness
                          2.0 + ([-days, 0].max / 7.0)
                        else
                          # for upcoming deadlines, add a value between 0.0 and 1.0
                          add = (30.0 - days) / 30.0
                          add = 0.0 if add < 0.0
                          add = 1.0 if add > 1.0
                          1.0 + add
                        end

      base = importance * 10.0
      effort_penalty = effort * 1.5

      score = base * time_multiplier - effort_penalty

      # Strong boost for overdue tasks to ensure they're prioritized
      score += 200 if deadline && deadline < Date.today

      score
    end
  end
end
