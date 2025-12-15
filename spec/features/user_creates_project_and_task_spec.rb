require 'rails_helper'

RSpec.feature "UserCreatesProjectAndTask", type: :feature do
  scenario "User signs up, creates a project, and adds a task" do
    visit new_user_registration_path
    fill_in "Email", with: "test2@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit new_project_path
    fill_in "Name", with: "Full Flow Project"
    fill_in "Description", with: "Full flow project description"
    click_button "Create Project"

    project = Project.last

    visit new_task_path
    fill_in "Title", with: "Full Flow Task"
    select project.name, from: "Project"
    click_button "Create Task"

    expect(page).to have_content("Task was successfully created")
  end
end
