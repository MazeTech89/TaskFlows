require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    # Use FactoryBot to build a persisted project for edit
    @project = assign(:project, FactoryBot.create(:project))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do
      assert_select "input[name=?]", "project[name]"
      assert_select "textarea[name=?]", "project[description]"
      assert_select "input[name=?]", "project[user_id]"
    end
  end
end
