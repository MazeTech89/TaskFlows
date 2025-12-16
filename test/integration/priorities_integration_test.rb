require "test_helper"

class PrioritiesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    sign_in @user
  end

  test "should list priorities" do
    Priority.create!(name: "High", score: 5.0)
    Priority.create!(name: "Low", score: 1.0)

    get priorities_path
    assert_response :success
    assert_select "h1", "Priorities"
  end
end
