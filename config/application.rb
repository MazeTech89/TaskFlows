require_relative "boot"

require "rails/all"

# Load gems from Gemfile
Bundler.require(*Rails.groups)

module Taskflows
  class Application < Rails::Application
    # Use Rails 8.1 defaults
    config.load_defaults 8.1

    # Auto-load lib directory, ignoring non-code subdirectories
    config.autoload_lib(ignore: %w[assets tasks])
  end
end

# Auto-load custom service and worker classes
Rails.autoloaders.main.push_dir("app/services")
Rails.autoloaders.main.push_dir("app/workers")
