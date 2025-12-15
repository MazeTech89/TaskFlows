require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password") }

  it "is valid with a name and user" do
    project = Project.new(name: "Test Project", user: user)
    expect(project).to be_valid
  end

  it "is invalid without a name" do
    project = Project.new(name: nil, user: user)
    expect(project).not_to be_valid
  end
end
