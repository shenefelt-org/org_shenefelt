Rails.application.routes.draw do
  get "home/index"
  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  # Token Generation Routes
  get  "/token", to: "token#new", as: :token
  post "/token", to: "token#create"

  # Protected Files Portal
  get    "/files",           to: "files#index",    as: :files
  post   "/files/login",     to: "files#login",    as: :files_login
  delete "/files/logout",    to: "files#logout",   as: :files_logout
  get    "/files/:filename", to: "files#download", as: :file_download, constraints: { filename: /[^\/]+/ }

  # Platform Sign Up / Registration
  get  "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"

  # Platform Sessions / Login (Rails 8 Authentication)
  resource :session, only: %i[ new create destroy ]
  get    "/login",  to: "sessions#new",     as: :login
  delete "/logout", to: "sessions#destroy", as: :logout

  # Password Resets (Rails 8 Authentication)
  resources :passwords, param: :token

  # Root Landing Page
  root "home#index"
end
