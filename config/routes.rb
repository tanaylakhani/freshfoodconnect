Rails.application.routes.draw do
  resource :location, only: [:create]
  resource :profile, only: [:show]

  resources :registrations, only: [:create, :new]
  resources :pre_registrations, only: [:create]
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"

  constraints Clearance::Constraints::SignedIn.new do
    get "/" => redirect("/profile")
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "marketing#index"
  end
end
