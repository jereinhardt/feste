Feste::Engine.routes.draw do
  get "cancelled_subscription/:token", to: "cancelled_subscriptions#show", as: :cancelled_subscription
  put "cancelled_subscription/:token", to: "cancelled_subscriptions#update"
  patch "cancelled_subscription/:token", to: "cancelled_subscriptions#update"
  # resources :cancelled_subscriptions, only: [:show, :update]
end