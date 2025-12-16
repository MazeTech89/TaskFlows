require "test_helper"

class PriorityTest < ActiveSupport::TestCase
  test "should validate presence of name" do
    priority = Priority.new(score: 5.0)
    assert_not priority.valid?
    assert_includes priority.errors[:name], "can't be blank"
  end

  test "should validate presence of score" do
    priority = Priority.new(name: "High")
    assert_not priority.valid?
    assert_includes priority.errors[:score], "can't be blank"
  end

  test "should validate uniqueness of name" do
    Priority.create!(name: "High", score: 5.0)
    priority = Priority.new(name: "High", score: 3.0)
    assert_not priority.valid?
    assert_includes priority.errors[:name], "has already been taken"
  end

  test "should be valid with name and score" do
    priority = Priority.new(name: "Medium", score: 3.0)
    assert priority.valid?
  end
end
