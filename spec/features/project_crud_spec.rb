require 'rails_helper'

RSpec.feature "ProjectManagement", type: :feature do
  let(:user) { User.create!(email: "user2@example.com", password: "password") }

  before { login_as(user, scope: :user) }

  scenario "User creates a project" do
    visit new_project_path
    fill_in "Name", with: "My First Project"
    click_button "Create Project"
    expect(page).to have_content("Project was successfully created")
  end
end
