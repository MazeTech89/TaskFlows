# Spec for TaskflowsUtils::PriorityScoring - tests priority calculation algorithm
require_relative '../lib/taskflows_utils'

RSpec.describe TaskflowsUtils::PriorityScoring do
  let(:scorer) { described_class.new }

  # Test: nearer deadlines should have higher scores
  it "gives a higher score for tasks with nearer deadlines" do
    score_soon = scorer.score(
      deadline: Date.today + 1,
      importance: 3,
      effort_hours: 2
    )

    score_later = scorer.score(
      deadline: Date.today + 7,
      importance: 3,
      effort_hours: 2
    )

    expect(score_soon).to be > score_later
  end

  # Test: high-effort tasks should have lower scores (effort penalty)
  it "gives a penalty for high-effort tasks" do
    easy = scorer.score(
      deadline: Date.today + 2,
      importance: 3,
      effort_hours: 1
    )

    hard = scorer.score(
      deadline: Date.today + 2,
      importance: 3,
      effort_hours: 10
    )

    expect(easy).to be > hard
  end

  # Test: overdue tasks get a strong priority boost
  it "increases score significantly if task is overdue" do
    score = scorer.score(
      deadline: Date.today - 1,
      importance: 2,
      effort_hours: 3
    )

    expect(score).to be > 100
  end

  # Test: scoring handles nil deadline gracefully
  it "always returns a numeric score" do
    score = scorer.score(deadline: nil, importance: 1, effort_hours: 2)
    expect(score).to be_a(Numeric)
  end
end
