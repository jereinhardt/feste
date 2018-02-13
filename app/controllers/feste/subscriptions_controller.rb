module Feste
  class SubscriptionsController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :find_or_create_subscriptions

    layout "feste/application"

    helper Feste::SubscriptionHelpers

    def index
      @subscriber = subscriber
    end

    def update
      @subscriber = subscriber
      if update_subscriptions
        flash[:success] = "You have successfully updated your subscriptions!"
      else
        flash[:notice] = "Something went wrong!  Please try again later."
      end
      redirect_to subscriptions_path(token: params[:token])
    end

    private

    def subscriber
      Feste::Subscription.find_by(token: params[:token]).subscriber
    end

    def user_params
      params.require(subscriber.class.to_s.downcase.to_sym).
        permit(subscription: [])
    end

    def subscriptions_params
      user_params[:subscription]
    end

    def update_subscriptions
      subscribed = Feste::Subscription.where(id: subscriptions_params)
      unsubscribed = Feste::Subscription.where.not(id: subscriptions_params)
      subscribed.update_all(canceled: false) && 
        unsubscribed.update_all(canceled: true)
    end

    def find_or_create_subscriptions
      Feste.options[:categories].each do |category|
        Feste::Subscription.find_or_create_by(
          subscriber: subscriber,
          category: category
        )
      end
    end
  end
end