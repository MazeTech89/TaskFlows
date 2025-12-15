require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    # Assign a new project instance using FactoryBot
    assign(:project, FactoryBot.build(:project))
  end

  it "renders new project form" do
    render

    # Check that the form points to the correct path with POST method
    assert_select "form[action=?][method=?]", projects_path, "post" do
      # Check for name input
      assert_select "input[name=?]", "project[name]"

      # Check for description textarea
      assert_select "textarea[name=?]", "project[description]"

      # Check for user_id input (hidden or select, depending on form)
      assert_select "input[name=?]", "project[user_id]"
    end
  end
end
