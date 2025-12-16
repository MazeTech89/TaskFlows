# Functional tests for Task#calculate_priority_score
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#calculate_priority_score' do
    let(:project) { create(:project, name: "Test Project") }
    let(:priority_high) { create(:priority, name: "High", score: 5.0) }
    let(:priority_low) { create(:priority, name: "Low", score: 1.0) }

    context 'with deadline and priority' do
      # Nearer deadlines should score higher
      it 'returns higher score for tasks with nearer deadlines' do
        task_soon = create(:task, 
          project: project,
          priority: priority_high,
          due_date: Date.today + 1,
          name: "Urgent task"
        )
        
        task_later = create(:task,
          project: project,
          priority: priority_high,
          due_date: Date.today + 30,
          name: "Future task"
        )
        
        expect(task_soon.calculate_priority_score).to be > task_later.calculate_priority_score
      end

      # Higher importance should score higher
      it 'returns higher score for more important tasks' do
        task_high = create(:task,
          project: project,
          priority: priority_high,
          due_date: Date.today + 7,
          name: "High priority"
        )
        
        task_low = create(:task,
          project: project,
          priority: priority_low,
          due_date: Date.today + 7,
          name: "Low priority"
        )
        
        expect(task_high.calculate_priority_score).to be > task_low.calculate_priority_score
      end
    end

    context 'with overdue tasks' do
      # Overdue tasks receive +200 boost
      it 'gives significantly higher score to overdue tasks' do
        overdue_task = create(:task,
          project: project,
          priority: priority_high,
          due_date: Date.today - 5,
          name: "Overdue task",
          completed: false
        )
        
        expect(overdue_task.calculate_priority_score).to be > 200
      end
    end

    context 'with nil deadline' do
      # Nil deadline treated as 365 days out
      it 'handles tasks without deadlines gracefully' do
        task = create(:task,
          project: project,
          priority: priority_high,
          due_date: nil,
          name: "No deadline"
        )
        
        expect(task.calculate_priority_score).to be_a(Numeric)
        expect(task.calculate_priority_score).to be > 0
      end
    end

    context 'with custom overrides' do
      # Runtime importance override
      it 'allows importance override' do
        task = create(:task,
          project: project,
          priority: priority_low,
          due_date: Date.today + 5
        )
        
        score_default = task.calculate_priority_score
        score_override = task.calculate_priority_score(importance_override: 10.0)
        
        expect(score_override).to be > score_default
      end

      # Runtime effort override (higher effort = lower score)
      it 'allows effort override' do
        task = create(:task,
          project: project,
          priority: priority_high,
          due_date: Date.today + 5
        )
        
        score_low_effort = task.calculate_priority_score(effort_override: 1.0)
        score_high_effort = task.calculate_priority_score(effort_override: 20.0)
        
        expect(score_low_effort).to be > score_high_effort
      end
    end
  end
end
