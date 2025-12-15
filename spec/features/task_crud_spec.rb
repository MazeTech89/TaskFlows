require 'rails_helper'

RSpec.feature "TaskManagement", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, user: user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User creates a task in a project" do
    visit new_task_path

    fill_in "Title", with: "New Task"
    select project.name, from: "Project"
    check "Completed" if page.has_field?("Completed")
    click_button "Create Task"

    expect(page).to have_content("Task was successfully created")
    expect(Task.last.project).to eq(project)
  end
end
