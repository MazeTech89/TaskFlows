# spec/features/project_crud_spec.rb
require 'rails_helper'

RSpec.feature "ProjectManagement", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User creates a project" do
    visit new_project_path
    fill_in "Name", with: "New Project"
    fill_in "Description", with: "Project description"
    click_button "Create Project"

    expect(page).to have_text("Project was successfully created")
    expect(Project.last.user).to eq(user)
  end
end
