# RSpec configuration for Rails tests
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Load RSpec Rails integration and test libraries
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'factory_bot_rails'
require 'devise'
require 'database_cleaner-active_record'

# Ensure test database schema is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Include test helpers
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include Capybara::DSL

  # Database cleanup strategy
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Clean database around each test
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
