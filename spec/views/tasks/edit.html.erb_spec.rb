require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    project = FactoryBot.create(:project)
    @task = assign(:task, FactoryBot.create(:task, project: project))
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do
      assert_select "input[name=?]", "task[title]"
      assert_select "input[name=?]", "task[completed]"
      assert_select "select[name=?]", "task[project_id]"
    end
  end
end
