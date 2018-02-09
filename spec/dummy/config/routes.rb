Rails.application.routes.draw do
  mount Feste::Engine => "/email-subscriptions"
end
