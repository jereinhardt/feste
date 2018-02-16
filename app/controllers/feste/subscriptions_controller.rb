module Feste
  class SubscriptionsController < ActionController::Base
    include Feste::Authenticatable

    protect_from_forgery with: :exception

    layout "feste/application"

    def index
      @subscriber = subscriber
    end

    def update
      if update_subscriptions
        flash[:success] = "You have successfully updated your subscriptions!"
      else
        flash[:notice] = "Something went wrong!  Please try again later."
      end
      redirect_back(
        fallback_location: subscriptions_path(token: params[:token])
      )
    end

    private

    def user_params
      params.require(subscriber.class.to_s.downcase.to_sym).
        permit(subscriptions: [])
    end

    def subscriptions_params
      user_params[:subscriptions]
    end

    def update_subscriptions
      subscribed = subscriber.subscriptions.where(id: subscriptions_params)
      unsubscribed = subscriber.subscriptions.where.
        not(id: subscriptions_params)
      subscribed.update_all(canceled: false) && 
        unsubscribed.update_all(canceled: true)
    end
  end
end