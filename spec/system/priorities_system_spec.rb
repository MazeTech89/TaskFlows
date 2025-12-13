require 'rails_helper'

RSpec.describe 'Priorities UI', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'has a placeholder failing system test for priorities UI' do
    visit root_path
    pending('Implement priorities UI and system tests')
    fail
  end
end
