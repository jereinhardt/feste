Feste::Engine.routes.draw do
  get "/", to: "subscriptions#index", as: :subscriptions
  put "/", to: "subscriptions#update"
  patch "/", to: "subscriptions#update"
end