require "test_helper"

class PrioritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @priority = Priority.create!(name: "High", score: 5.0)
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    sign_in @user
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
