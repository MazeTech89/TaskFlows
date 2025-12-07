require 'rails_helper'

RSpec.feature "UserCreatesProjectAndTask", type: :feature do
  scenario "user signs up, creates a project, and adds a task" do
    visit new_user_registration_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    expect(page).to have_content("Welcome") or expect(page).to have_content("Signed in successfully")

    click_link "New Project"
    fill_in "Title", with: "Home"
    click_button "Create Project"
    expect(page).to have_content("Project was successfully created")

    click_link "Add Task"
    fill_in "Title", with: "Do laundry"
    click_button "Create Task"
    expect(page).to have_content("Task was successfully created")
    expect(page).to have_content("Do laundry")
  end
end
