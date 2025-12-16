# taskflows_utils — Priority scoring

This small utility gem provides a deterministic priority scoring function used to rank tasks.

## Purpose

The scoring algorithm converts task metadata (deadline, importance, and estimated effort) into a numeric score. Higher scores indicate higher priority.

## API

Class: `TaskflowsUtils::PriorityScoring`

Method: `#score(deadline:, importance:, effort_hours:, current_date: Date.today)`

- `deadline` — a `Date` or `nil` (nil means no deadline / far future)
- `importance` — numeric importance (higher is more important, 1-5 typical scale)
- `effort_hours` — numeric estimate of the effort in hours (higher reduces priority)
- `current_date` — optional Date for testing (defaults to `Date.today`)

Returns a `Numeric` score.

## Configuration Constants

The algorithm uses these tunable constants:
- `IMPORTANCE_MULTIPLIER = 10.0` - Base score multiplier for importance
- `EFFORT_PENALTY_RATE = 1.5` - Penalty rate per hour of effort
- `OVERDUE_BASE_MULTIPLIER = 2.0` - Base multiplier for overdue tasks
- `OVERDUE_BOOST = 200.0` - Fixed score boost for overdue tasks
- `LATENESS_SCALE_DAYS = 7.0` - Days divisor for lateness scaling
- `PROXIMITY_WINDOW_DAYS = 30.0` - Days window for deadline proximity bonus
- `NO_DEADLINE_DEFAULT_DAYS = 365.0` - Default days for tasks with no deadline

## Algorithm (summary)

1. Normalize inputs to floats; treat `nil` deadline as far in the future (365 days).
2. Compute `days = (deadline - current_date)` (or 365 when `nil`).
3. Compute a `time_multiplier`:
   - If `days <= 0` (overdue): `time_multiplier = 2.0 + (days.abs / 7.0)` (grows with lateness) plus fixed overdue boost.
   - If `days > 0` (not overdue): compute an additive factor proportional to how close the deadline is within 30 days; clamp that add between `0.0` and `1.0`; then `time_multiplier = 1.0 + add`.
4. Compute `base = importance * 10.0`.
5. Compute `effort_penalty = effort_hours * 1.5`.
6. Score = `base * time_multiplier - effort_penalty`.
7. If overdue, also add a fixed boost of `+200` to ensure overdue tasks get high priority.

This yields a score where:
- Closer deadlines increase the multiplier and therefore the score.
- Higher `importance` scales the base score linearly.
- Higher `effort_hours` subtracts from the score.
- Overdue tasks receive a substantial boost so they appear at top of lists.
- The more overdue a task is, the higher its multiplier grows.

## Example

```ruby
scorer = TaskflowsUtils::PriorityScoring.new
scorer.score(deadline: Date.today + 1, importance: 3, effort_hours: 2)
# => ~56.0

# Test with fixed date
scorer.score(
  deadline: Date.new(2025, 1, 20), 
  importance: 4, 
  effort_hours: 3, 
  current_date: Date.new(2025, 1, 15)
)
# => ~72.5
```

## Integration with Rails

This gem is integrated with the `Task` model via `calculate_priority_score` method:

```ruby
task = Task.find(1)
task.calculate_priority_score  # Uses task's due_date, priority.score, and default effort
task.calculate_priority_score(importance_override: 5, effort_override: 10)
```

## Improvements (v0.2.0)

- ✅ **Fixed lateness bug**: Corrected overdue multiplier calculation using `days.abs`
- ✅ **Extracted constants**: All magic numbers now configurable
- ✅ **Added validation**: Raises ArgumentError if deadline is not a Date
- ✅ **Testable dates**: Accepts `current_date` parameter for deterministic testing
- ✅ **Comprehensive tests**: Added edge case tests for validation, nil handling, lateness scaling

## Notes

- The algorithm is intentionally simple and deterministic to make tests predictable.
- Feel free to tweak constants to match your product priorities.
- All tests use fixed dates to ensure reproducibility.

## Running tests

From the repository root you can run the gem's specs:

```powershell
Push-Location taskflows_utils
bundle exec rspec spec/priority_scoring_spec.rb --format documentation --color
Pop-Location
```
## Notes
PostgreSQL database ownership must match the Rails DB user to avoid schema_migrations permission errors.

## PostgreSQL Database Permissions Fix

**Date:** 2025-12-13  
**Author:** Mo Ade  

To prevent `PG::InsufficientPrivilege` errors during Rails migrations:

1. Ensure the Rails database user matches the database owner.
2. Grant all privileges to the Rails user on the database, tables, sequences, and functions.
3. Apply `ALTER DEFAULT PRIVILEGES` for future tables and sequences.

### Commands Used
```sql
ALTER DATABASE taskflows_test OWNER TO mosesa;

GRANT ALL PRIVILEGES ON DATABASE taskflows_test TO mosesa;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mosesa;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mosesa;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO mosesa;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO mosesa;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON SEQUENCES TO mosesa;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON FUNCTIONS TO mosesa;
