require "rails_helper"

RSpec.describe "projects/index", type: :view do
  before do
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assign(:projects, [
      Project.create!(
        name: "Project One",
        description: "Description One",
        user: user
      ),
      Project.create!(
        name: "Project Two",
        description: "Description Two",
        user: user
      )
    ])
  end

  it "renders a list of projects" do
    render
    expect(rendered).to match(/Project One/)
    expect(rendered).to match(/Project Two/)
  end
end
