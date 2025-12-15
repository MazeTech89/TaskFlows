require 'rails_helper'

RSpec.feature "UserAuthentication", type: :feature do
  scenario "User signs up successfully" do
    visit new_user_registration_path

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully")
  end

  scenario "User logs in successfully" do
    user = FactoryBot.create(:user, password: "password")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
  end







  
  scenario "Unauthorized user cannot access projects page" do
    visit projects_path
    expect(current_path).to eq(new_user_session_path)
  end
end
