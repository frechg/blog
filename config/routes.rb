Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "users", only: [:new, :create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  get "/sign_in", to: "sessions#new", as: "sign_in"
  delete "/sign_out", to: "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up", to: "users#new", as: "sign_up"
  root "articles#index"

  resources :articles do
    resources :frames, only: [:new, :create]
    resources :invites, only: [:new, :create, :show]
  end

  get "/accept_invite", to: "invites#accept", as: "accept_invite"

end
