require "sidekiq/web"

Rails.application.routes.draw do
  resources :quotes
  resources :products, path: "shop"
  resources :order_items
  resources :orders
  mount Sidekiq::Web => "/sidekiq"
  post "checkout/create", to: "checkout#create", as: :checkout_create

  resources :user_managers, path: "user_manager"
  get "manager/users", to: "user_manager#index"
  get "manager/users/new", to: "user_manager#new"
# Injury reports
resources :injury_reports, only: [ :index, :show, :create ], path: "injury-reports"
get "report-injury", to: "injury_reports#new", as: :report_injury

  # resources :portfolios
  resources :client_contacts
  resources :funko_pops, path: "funko"
  resources :contacts, path: "contact"
  resources :files, only: %i[index new create destroy] do
    get :download, on: :collection
    get :upload, on: :collection
    post :upload, on: :collection
    delete :destroy, on: :collection
  end
  resources :evolution_chains
  resources :pokemons, path: "pokemon"
  get "home/index"
  get "about", to: "home#about"
  # get "portfolio", to: "home#portfolio", as: :portfolio
  # use as: to create a path. so here we have ip_path now
  get "ip", to: "home#ip", as: :ip

  # portfolio routes
  get "portfolio", to: "portfolios#index", as: :portfolio
  get "portfolio/pub-ip", to: "portfolios#ip_addr", as: :public_ip


  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  match "/auth/openid_connect",
      to: "sso#start",
      via: [ :get, :post ],
      as: :openid_connect

  get  "/auth/openid_connect/callback",       to: "sso#callback"
  post "/auth/openid_connect/callback",       to: "sso#callback"

  # Authentik is currently sending users here NEVER DELETE THIS LINE OR SSO IS GONE
  get  "/users/auth/openid_connect/callback", to: "sso#callback"
  post "/users/auth/openid_connect/callback", to: "sso#callback"

  # Token Generation Routes
  get  "/token", to: "token#new", as: :token
  post "/token", to: "token#create"


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
  root "home#about"
end
