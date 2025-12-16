require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "sign up redirects to dashboard" do
    get new_user_registration_path
    assert_response :success

    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to dashboard_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "Dashboard"
  end

  test "sign in redirects to dashboard" do
    user = User.create!(email: "existing@example.com", password: "password123", password_confirmation: "password123")

    get new_user_session_path
    assert_response :success

    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }

    assert_redirected_to dashboard_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "Dashboard"
  end

  test "sign out redirects to root" do
    user = User.create!(email: "signout@example.com", password: "password123", password_confirmation: "password123")
    sign_in user

    delete destroy_user_session_path

    assert_redirected_to root_path
    follow_redirect!
    # Should redirect to sign in page since root requires authentication
    assert_redirected_to new_user_session_path
  end
end
