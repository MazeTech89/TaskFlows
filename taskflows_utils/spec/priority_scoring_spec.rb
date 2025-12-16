# Spec for TaskflowsUtils::PriorityScoring - tests priority calculation algorithm
require_relative '../lib/taskflows_utils'

RSpec.describe TaskflowsUtils::PriorityScoring do
  let(:scorer) { described_class.new }
  let(:today) { Date.new(2025, 1, 15) }

  # Test: nearer deadlines should have higher scores
  it "gives a higher score for tasks with nearer deadlines" do
    score_soon = scorer.score(
      deadline: today + 1,
      importance: 3,
      effort_hours: 2,
      current_date: today
    )

    score_later = scorer.score(
      deadline: today + 7,
      importance: 3,
      effort_hours: 2,
      current_date: today
    )

    expect(score_soon).to be > score_later
  end

  # Test: high-effort tasks should have lower scores (effort penalty)
  it "gives a penalty for high-effort tasks" do
    easy = scorer.score(
      deadline: today + 2,
      importance: 3,
      effort_hours: 1,
      current_date: today
    )

    hard = scorer.score(
      deadline: today + 2,
      importance: 3,
      effort_hours: 10,
      current_date: today
    )

    expect(easy).to be > hard
  end

  # Test: overdue tasks get a strong priority boost
  it "increases score significantly if task is overdue" do
    score = scorer.score(
      deadline: today - 1,
      importance: 2,
      effort_hours: 3,
      current_date: today
    )

    expect(score).to be > 100
  end

  # Test: scoring handles nil deadline gracefully
  it "always returns a numeric score" do
    score = scorer.score(
      deadline: nil,
      importance: 1,
      effort_hours: 2,
      current_date: today
    )
    expect(score).to be_a(Numeric)
  end

  # Test: lateness multiplier grows with overdue days
  it "increases score more for tasks that are very overdue" do
    one_day_late = scorer.score(
      deadline: today - 1,
      importance: 3,
      effort_hours: 2,
      current_date: today
    )

    week_late = scorer.score(
      deadline: today - 7,
      importance: 3,
      effort_hours: 2,
      current_date: today
    )

    expect(week_late).to be > one_day_late
  end

  # Test: validates deadline is a Date
  it "raises error if deadline is not a Date" do
    expect {
      scorer.score(
        deadline: "2025-01-15",
        importance: 3,
        effort_hours: 2,
        current_date: today
      )
    }.to raise_error(ArgumentError, /deadline must be a Date/)
  end

  # Test: handles nil importance and effort
  it "treats nil importance and effort as zero" do
    score = scorer.score(
      deadline: today + 5,
      importance: nil,
      effort_hours: nil,
      current_date: today
    )
    expect(score).to be_a(Numeric)
    expect(score).to be >= 0
  end

  # Test: higher importance increases score
  it "gives higher scores for more important tasks" do
    low_importance = scorer.score(
      deadline: today + 5,
      importance: 1,
      effort_hours: 2,
      current_date: today
    )

    high_importance = scorer.score(
      deadline: today + 5,
      importance: 5,
      effort_hours: 2,
      current_date: today
    )

    expect(high_importance).to be > low_importance
  end

  # Test: zero effort tasks get full score (no penalty)
  it "gives no penalty for zero-effort tasks" do
    with_effort = scorer.score(
      deadline: today + 5,
      importance: 3,
      effort_hours: 5,
      current_date: today
    )

    no_effort = scorer.score(
      deadline: today + 5,
      importance: 3,
      effort_hours: 0,
      current_date: today
    )

    expect(no_effort).to be > with_effort
  end
end
