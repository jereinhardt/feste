Feste::Engine.routes.draw do
  get "subscriptions/:token", to: "subscriptions#index", as: :subscriptions
  put "subscriptions/:token", to: "subscriptions#update"
  patch "subscriptions/:token", to: "subscriptions#update"
end