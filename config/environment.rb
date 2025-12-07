# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.autoloaders.main.push_dir("app/services")
Rails.autoloaders.main.push_dir("app/workers")
