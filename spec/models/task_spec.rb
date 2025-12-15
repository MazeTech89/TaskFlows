require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:priority) { create(:priority, name: "High") }

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:priority).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'scopes' do
    let!(:completed_task) { create(:task, project: project, name: "Done", completed: true) }
    let!(:pending_task) { create(:task, project: project, name: "Pending", completed: false) }
    let!(:overdue_task) { create(:task, project: project, name: "Late", completed: false, due_date: 2.days.ago) }

    describe '.completed' do
      it 'returns only completed tasks' do
        expect(Task.completed).to include(completed_task)
        expect(Task.completed).not_to include(pending_task)
      end
    end

    describe '.pending' do
      it 'returns only pending tasks' do
        expect(Task.pending).to include(pending_task)
        expect(Task.pending).to include(overdue_task)
        expect(Task.pending).not_to include(completed_task)
      end
    end

    describe '.overdue' do
      it 'returns only overdue tasks' do
        expect(Task.overdue).to include(overdue_task)
        expect(Task.overdue).not_to include(pending_task)
      end
    end

    describe '.by_project' do
      let(:another_project) { create(:project, user: user, name: "Another") }
      let!(:another_task) { create(:task, project: another_project, name: "Other") }

      it 'filters tasks by project_id' do
        expect(Task.by_project(project.id)).to include(completed_task)
        expect(Task.by_project(project.id)).not_to include(another_task)
      end
    end
  end

  describe 'instance methods' do
    describe '#overdue?' do
      it 'returns true when task is overdue' do
        task = create(:task, project: project, name: "Late", due_date: 1.day.ago, completed: false)
        expect(task.overdue?).to be true
      end

      it 'returns false when task is not overdue' do
        task = create(:task, project: project, name: "Future", due_date: 1.day.from_now, completed: false)
        expect(task.overdue?).to be false
      end

      it 'returns false when task is completed' do
        task = create(:task, project: project, name: "Done", due_date: 1.day.ago, completed: true)
        expect(task.overdue?).to be false
      end
    end

    describe '#status' do
      it 'returns "Overdue" when task is overdue' do
        task = create(:task, project: project, name: "Late", due_date: 1.day.ago, completed: false)
        expect(task.status).to eq('Overdue')
      end

      it 'returns "Completed" when task is completed' do
        task = create(:task, project: project, name: "Done", completed: true)
        expect(task.status).to eq('Completed')
      end

      it 'returns "Pending" when task is pending' do
        task = create(:task, project: project, name: "Todo", completed: false)
        expect(task.status).to eq('Pending')
      end
    end
  end
end
