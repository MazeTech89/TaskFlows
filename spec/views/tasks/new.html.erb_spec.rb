require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    # Assign a new task instance with an associated project
    project = FactoryBot.create(:project)
    assign(:task, FactoryBot.build(:task, project: project))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do
      assert_select "input[name=?]", "task[title]"
      assert_select "input[name=?]", "task[completed]"
      assert_select "select[name=?]", "task[project_id]"
    end
  end
end
