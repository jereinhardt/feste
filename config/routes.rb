Feste::Engine.routes.draw do
  get "subscription/:token", to: "subscriptions#show", as: :subscription
  put "subscription/:token", to: "subscriptions#update"
  patch "subscription/:token", to: "subscriptions#update"
end