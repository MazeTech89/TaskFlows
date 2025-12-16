require 'rails_helper'

RSpec.feature "Dashboard", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user, name: "Test Project") }
  let!(:priority) { create(:priority, name: "Medium") }

  before do
    sign_in user
  end

  scenario "User views dashboard with statistics" do
    create(:task, project: project, name: "Task 1", completed: true)
    create(:task, project: project, name: "Task 2", completed: false)
    create(:task, project: project, name: "Task 3", completed: true, due_date: 1.day.ago)

    visit dashboard_path

    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Total Tasks")
    expect(page).to have_content("3")
    expect(page).to have_content("Completed")
    expect(page).to have_content("2")
    expect(page).to have_content("Pending")
    expect(page).to have_content("1")
  end

  scenario "User views recent tasks on dashboard" do
    create(:task, project: project, name: "Recent Task 1")
    create(:task, project: project, name: "Recent Task 2")

    visit dashboard_path

    expect(page).to have_content("Recent Tasks")
    expect(page).to have_content("Recent Task 1")
    expect(page).to have_content("Recent Task 2")
  end

  scenario "User sees completion rate" do
    create(:task, project: project, name: "Done", completed: true)
    create(:task, project: project, name: "Pending", completed: false)

    visit dashboard_path

    expect(page).to have_content("Overall Completion Rate")
    expect(page).to have_content("50")
  end
end
