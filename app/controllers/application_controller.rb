# Base controller - all other controllers inherit from this
class ApplicationController < ActionController::Base
  # Only allow modern browsers with webp, web push, CSS nesting support
  allow_browser versions: :modern

  # Invalidate cache when importmap changes
  stale_when_importmap_changes

  # Require user login for all actions (Devise)
  before_action :authenticate_user!

  # Redirect to dashboard after successful sign in
  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
