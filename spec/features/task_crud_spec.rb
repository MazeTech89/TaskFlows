require 'rails_helper'

RSpec.feature "TaskManagement", type: :feature do
  let(:user) { User.create!(email: "user4@example.com", password: "password") }
  let(:project) { Project.create!(name: "Project B", user: user) }

  before { login_as(user, scope: :user) }

  scenario "User creates a task in a project" do
    visit new_project_task_path(project)
    fill_in "Name", with: "Finish TDD roadmap"
    click_button "Create Task"
    expect(page).to have_content("Task was successfully created")
  end
end
