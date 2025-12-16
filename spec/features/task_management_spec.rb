require 'rails_helper'

RSpec.feature "Task Management", type: :feature do
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user, name: "My Project") }
  let!(:priority) { create(:priority, name: "High") }

  before do
    sign_in user
  end

  scenario "User creates a new task" do
    visit new_project_task_path(project)

    fill_in "Task Name", with: "Complete the report"
    fill_in "task_due_date", with: 2.days.from_now.to_date
    select "High", from: "task_priority_id"

    click_button "Save Task"

    expect(page).to have_content("Task was successfully created")
    expect(page).to have_content("Complete the report")
  end

  scenario "User views all tasks" do
    create(:task, project: project, name: "Task 1", completed: false)
    create(:task, project: project, name: "Task 2", completed: true)

    visit tasks_path

    expect(page).to have_content("Task 1")
    expect(page).to have_content("Task 2")
    expect(page).to have_content("Pending")
    expect(page).to have_content("Completed")
  end

  scenario "User filters tasks by completion status" do
    create(:task, project: project, name: "Done Task", completed: true)
    create(:task, project: project, name: "Pending Task", completed: false)

    visit tasks_path

    select "Completed", from: "status"
    click_button "Filter"

    expect(page).to have_content("Done Task")
    expect(page).not_to have_content("Pending Task")
  end

  scenario "User searches for tasks" do
    create(:task, project: project, name: "Write documentation")
    create(:task, project: project, name: "Fix bug")

    visit tasks_path

    fill_in "search", with: "documentation"
    click_button "Filter"

    expect(page).to have_content("Write documentation")
    expect(page).not_to have_content("Fix bug")
  end

  scenario "User updates a task" do
    task = create(:task, project: project, name: "Original name", completed: false)

    visit edit_task_path(task)

    fill_in "Task Name", with: "Updated name"
    check "task_completed"

    click_button "Save Task"

    expect(page).to have_content("Task was successfully updated")
    expect(page).to have_content("Updated name")
  end

  scenario "User deletes a task" do
    task = create(:task, project: project, name: "Delete me")

    visit tasks_path

    expect(page).to have_content("Delete me")

    # Find the delete button for the specific task and click it
    within("tr", text: "Delete me") do
      click_button "Delete"
    end

    expect(page).to have_content("Task was successfully destroyed")
    expect(page).not_to have_content("Delete me")
  end
end
