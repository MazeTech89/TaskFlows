# Base controller - all other controllers inherit from this
class ApplicationController < ActionController::Base
  # Only allow modern browsers with webp, web push, CSS nesting support
  allow_browser versions: :modern

  # Invalidate cache when importmap changes
  stale_when_importmap_changes

  # Require user login for all actions (Devise)
  before_action :authenticate_user!
end
