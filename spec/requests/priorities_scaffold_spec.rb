require 'rails_helper'

RSpec.describe "Priorities scaffold (requests)", type: :request do
  # These specs are scaffold-level acceptance tests for a Priority resource.
  # They are intentionally written before implementation to follow TDD:
  # - create the failing tests first
  # - implement the scaffold to make them pass

  describe 'GET /priorities' do
    it 'routes to index and returns a successful response' do
      get '/priorities'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /priorities/:id' do
    it 'returns 200 for show' do
      # a Priority resource does not exist yet; we expect a failing test here
      get '/priorities/1'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /priorities' do
    it 'creates a priority and redirects (or returns created)' do
      post '/priorities', params: { priority: { name: 'High', score: 10.0 } }
      expect(response).to satisfy { |r| [201, 302].include?(r.status) }
    end
  end

  describe 'PATCH /priorities/:id' do
    it 'updates a priority' do
      patch '/priorities/1', params: { priority: { name: 'Updated' } }
      expect(response).to satisfy { |r| [200, 302].include?(r.status) }
    end
  end

  describe 'DELETE /priorities/:id' do
    it 'destroys a priority' do
      delete '/priorities/1'
      expect(response).to satisfy { |r| [200, 302, 204].include?(r.status) }
    end
  end
end
