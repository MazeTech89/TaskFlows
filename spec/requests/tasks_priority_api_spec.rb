require 'rails_helper'

RSpec.describe "Tasks API with Priority Scoring", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:priority_high) { create(:priority, name: "High", score: 5.0) }
  let(:priority_medium) { create(:priority, name: "Medium", score: 3.0) }
  let(:priority_low) { create(:priority, name: "Low", score: 1.0) }

  # Helper to perform authenticated requests
  def authenticated_request(method, path, **options)
    # Use Warden test helper to log in user
    login_as(user, scope: :user)
    send(method, path, **options)
  end

  describe 'GET /tasks with priority sorting' do
    it 'returns tasks sorted by calculated priority score' do
      # Log in user for request
      login_as(user, scope: :user)
      
      # Create tasks with different priorities and deadlines
      overdue_task = create(:task,
        project: project,
        priority: priority_medium,
        due_date: Date.today - 2,
        name: "Overdue",
        completed: false
      )

      urgent_task = create(:task,
        project: project,
        priority: priority_high,
        due_date: Date.today + 1,
        name: "Urgent"
      )

      future_task = create(:task,
        project: project,
        priority: priority_low,
        due_date: Date.today + 30,
        name: "Future"
      )

      get '/tasks', params: { sort_by: 'priority_score' }, headers: { 'Accept' => 'application/json' }
      
      expect(response).to have_http_status(:success)
      
      # Parse JSON response
      json = JSON.parse(response.body)
      task_scores = json.map { |t| 
        Task.find(t['id']).calculate_priority_score 
      }
      
      # Verify tasks are sorted by priority score (highest first)
      expect(task_scores).to eq(task_scores.sort.reverse)
      
      # Verify overdue task has highest score
      expect(json.first['id']).to eq(overdue_task.id)
    end
  end

  describe 'POST /tasks with priority calculation' do
    it 'creates task and calculates priority score on the fly' do
      login_as(user, scope: :user)
      
      post "/projects/#{project.id}/tasks", params: {
        task: {
          name: 'New task',
          project_id: project.id,
          priority_id: priority_high.id,
          due_date: Date.today + 2
        }
      }

      expect(response).to have_http_status(:redirect)
      
      created_task = Task.last
      expect(created_task.calculate_priority_score).to be > 40
    end
  end

  describe 'PATCH /tasks/:id with priority update' do
    it 'updates task priority and recalculates score' do
      login_as(user, scope: :user)
      
      task = create(:task,
        project: project,
        priority: priority_low,
        due_date: Date.today + 5,
        name: "Test task"
      )

      initial_score = task.calculate_priority_score

      patch "/tasks/#{task.id}", params: {
        task: { priority_id: priority_high.id }
      }

      expect(response).to have_http_status(:redirect)
      
      task.reload
      new_score = task.calculate_priority_score
      
      expect(new_score).to be > initial_score
    end
  end
end
