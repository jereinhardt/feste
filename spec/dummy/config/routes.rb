Rails.application.routes.draw do
  mount Feste::Engine => "/email-subscriptions", as: "feste"

  namespace :admin do
    mount Feste::Admin::Engine => "feste"
  end
end
