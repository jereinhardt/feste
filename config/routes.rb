Feste::Engine.routes.draw do
  get "cancelled_subscription/:token", to: "cancelled_subscriptions#show", as: :cancelled_subscription
  put "cancelled_subscription/:token", to: "cancelled_subscriptions#update"
  patch "cancelled_subscription/:token", to: "cancelled_subscriptions#update"
  get "subscriber/:token", to: "subscribers#show", as: :subscriber
  put "subscriber/:token", to: "subscribers#update"
  patch "subscriber/:token", to: "subscribers#update"
end