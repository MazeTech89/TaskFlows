# taskflows_utils — Priority scoring

This small utility gem provides a deterministic priority scoring function used to rank tasks.

## Purpose

The scoring algorithm converts task metadata (deadline, importance, and estimated effort) into a numeric score. Higher scores indicate higher priority.

## API

Class: `TaskflowsUtils::PriorityScoring`

Method: `#score(deadline:, importance:, effort_hours:)`

- `deadline` — a `Date` or `nil` (nil means no deadline / far future)
- `importance` — numeric importance (higher is more important)
- `effort_hours` — numeric estimate of the effort in hours (higher reduces priority)

Returns a `Numeric` score.

## Algorithm (summary)

1. Normalize inputs to floats; treat `nil` deadline as far in the future (365 days).
2. Compute `days = (deadline - Date.today)` (or 365 when `nil`).
3. Compute a `time_multiplier`:
   - If `days <= 0` (overdue): `time_multiplier = 2.0 + (lateness_in_days / 7.0)` (this grows for more overdue tasks) and we also add a fixed overdue boost later.
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

## Example

```ruby
scorer = TaskflowsUtils::PriorityScoring.new
scorer.score(deadline: Date.today + 1, importance: 3, effort_hours: 2)
```

## Notes

- The algorithm is intentionally simple and deterministic to make tests predictable.
- Feel free to tweak multipliers and penalties to match your product priorities.

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
