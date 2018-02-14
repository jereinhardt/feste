Rails.application.routes.draw do
  mount Feste::Engine => "/email-subscriptions", as: "feste"
end
