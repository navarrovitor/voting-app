Rails.application.routes.draw do
  get "/health", to: "health#show"
  get "/favicon.ico", to: proc { [204, {}, []] }
  get "/.well-known/*path", to: proc { [204, {}, []] }

  namespace :api do
    post "auth/request",  to: "auth#request_link"
    get  "auth/verify",   to: "auth#verify"
    get  "auth/me",       to: "auth#me"

    get  "categories",    to: "contestants#categories"
    get  "results",       to: "results#index"

    post "votes",         to: "votes#create"
  end

  namespace :admin do
    post "login",         to: "sessions#create"

    resources :contestants, only: [:index, :create, :update, :destroy]
    post "settings",      to: "settings#update"
    get  "settings",      to: "settings#show"
    get  "results",       to: "results#index"
  end
end
