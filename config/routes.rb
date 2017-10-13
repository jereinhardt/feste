Feste::Engine.routes.draw do
  get "subscription/:token", to: "cancelled_subscriptions#show", as: :cancelled_subscription
  put "subscription/:token", to: "cancelled_subscriptions#update"
  patch "subscription/:token", to: "cancelled_subscriptions#update"
end