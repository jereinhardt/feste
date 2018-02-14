module Feste
  class SubscriptionsController < ActionController::Base
    include Feste::Authentication

    protect_from_forgery with: :exception

    before_action :get_user_data

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
      redirect_to subscriptions_path(token: params[:token])
    end

    private

    def subscriber
      @_subscriber ||= current_user ||
        Feste::Subscription.find_by(token: params[:token])&.subscriber
    end

    def user_params
      params.require(subscriber.class.to_s.downcase.to_sym).
        permit(subscriptions: [])
    end

    def subscriptions_params
      user_params[:subscriptions]
    end

    def update_subscriptions
      subscribed = Feste::Subscription.where(id: subscriptions_params)
      unsubscribed = Feste::Subscription.where.not(id: subscriptions_params)
      subscribed.update_all(canceled: false) && 
        unsubscribed.update_all(canceled: true)
    end

    def get_user_data
      if subscriber.present?
        find_or_create_subscriptions
      else
        render file: "#{Rails.root}/public/404.html",  status: 404
      end
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