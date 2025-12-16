require "test_helper"

class PrioritiesIntegrationTest < ActionDispatch::IntegrationTest
  test "should list priorities" do
    Priority.create!(name: "High", score: 5.0)
    Priority.create!(name: "Low", score: 1.0)

    get priorities_path
    assert_response :success
    assert_select "h1", "Priorities"
  end
end
