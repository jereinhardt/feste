Feste::Engine.routes.draw do
  resources :subscriptions, path: "/", only: [:index]
  resource :subscriptions, path: "/", only: [:update]
end

Feste::Admin::Engine.routes.draw do
  resources :categories, path: "/", except: [:show]
end