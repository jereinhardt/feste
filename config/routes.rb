Feste::Engine.routes.draw do
  get "cancelled_subscriptions/:token", to: "cancelled_subscriptions#new", as: :new_cancelled_subscription
  post "cancelled_subscriptions/:token", to: "cancelled_subscriptions#create", as: :cancelled_subscription
end