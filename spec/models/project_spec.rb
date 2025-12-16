require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(500) }
    it { should allow_value(nil).for(:description) }
  end

  describe 'scopes' do
    it 'orders projects by recent' do
      old_project = create(:project, user: user, created_at: 2.days.ago)
      new_project = create(:project, user: user, created_at: 1.day.ago)

      expect(Project.recent.first).to eq(new_project)
    end
  end

  describe 'instance methods' do
    let(:project) { create(:project, user: user) }

    describe '#completion_rate' do
      it 'returns 0 when there are no tasks' do
        expect(project.completion_rate).to eq(0)
      end

      it 'calculates completion rate correctly' do
        create(:task, project: project, completed: true, name: "Task 1")
        create(:task, project: project, completed: false, name: "Task 2")
        create(:task, project: project, completed: true, name: "Task 3")

        expect(project.completion_rate).to eq(66.67)
      end
    end

    describe '#tasks_count' do
      it 'returns the correct number of tasks' do
        create(:task, project: project, name: "Task 1")
        create(:task, project: project, name: "Task 2")

        expect(project.tasks_count).to eq(2)
      end
    end
  end
end
