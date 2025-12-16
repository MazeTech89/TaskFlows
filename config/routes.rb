# Application routes - maps URLs to controller actions
Rails.application.routes.draw do
  # Devise authentication routes for users (/users/sign_in, /users/sign_up, etc.)
  devise_for :users

  # Root path and dashboard
  root "dashboard#index"
  get "/dashboard", to: "dashboard#index", as: :dashboard

  # Nested routes: create tasks within project context
  resources :projects do
    resources :tasks, only: [ :new, :create ]
  end

  # Standalone task routes (show, edit, update, destroy)
  resources :tasks, except: [ :new, :create ]

  # Priority management routes
  resources :priorities

  # User profile routes
  resource :user,
         path: "users",
         controller: "users",
         path_names: { new: "signup" }

  # Health check endpoint for monitoring (returns 200 if app is running)
  get "up" => "rails/health#show", as: :rails_health_check
end
