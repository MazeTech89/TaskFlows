require "application_system_test_case"

class PrioritiesSystemTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    Priority.create!(name: "High", score: 5.0)
    Priority.create!(name: "Low", score: 1.0)
  end

  test "visiting priorities index" do
    sign_in @user
    visit priorities_url

    assert_selector "h1", text: "Priorities"
    assert_text "High"
    assert_text "Low"
  end
end
