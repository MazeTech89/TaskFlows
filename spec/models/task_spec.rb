require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:project) }
  it { should validate_presence_of(:title) }

  it "has default status incomplete" do
    project = create(:project)
    task = Task.create(title: "My task", project: project)
    expect(task.status).to eq("incomplete")
  end
end

