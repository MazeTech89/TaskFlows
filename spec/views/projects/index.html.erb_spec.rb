require 'rails_helper'

let(:user) { FactoryBot.create(:user) }
let!(:projects) { FactoryBot.create_list(:project, 3, user: user) }

before do
  assign(:projects, projects)
end


RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        name: "Name",
        description: "MyText",
        user: nil
      ),
      Project.create!(
        name: "Name",
        description: "MyText",
        user: nil
      )
    ])
  end

  it "renders a list of projects" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
