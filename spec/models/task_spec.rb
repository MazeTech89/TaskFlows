require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create!(email: "user3@example.com", password: "password") }
  let(:project) { Project.create!(name: "Project A", user: user) }

  it "is valid with a name and project" do
    task = Task.new(name: "Do something", project: project)
    expect(task).to be_valid
  end

  it "is invalid without a name" do
    task = Task.new(name: nil, project: project)
    expect(task).not_to be_valid
  end
end
