require "test_helper"

class PrioritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @priority = Priority.create!(name: "High", score: 5.0)
  end

  test "should get index" do
    get priorities_url
    assert_response :success
  end

  test "should show priority" do
    get priority_url(@priority)
    assert_response :success
  end
end
