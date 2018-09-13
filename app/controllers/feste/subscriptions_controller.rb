module Feste
  class SubscriptionsController < ActionController::Base
    include Feste::Authenticatable

    protect_from_forgery with: :exception

    layout "feste/application"

    def index
      @subscriber = subscriber
    end

    def update
      events = set_subscribable_events
      if update_subscriptions
        publish_subscribable_events(events)
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

    def set_subscribable_events
      events = []
      if Feste.options[:event_subscriber].present?
        events << unsubscribe_event if user_unsubscribing_from_emails?
        events << resubscribe_event if user_resubscribing_to_emails?
      end
      events
    end

    def user_unsubscribing_from_emails?
      subscription_ids = user_params[:subscriptions]&.map(&:to_i) || []
      subscriber.subscriptions.where(canceled: false).pluck(:id).sort !=
        subscription_ids.sort
    end

    def user_resubscribing_to_emails?
      subscription_ids = user_params[:subscriptions]&.map(&:to_i) || []
      subscriber.subscriptions.where(canceled: true).pluck(:id).any? do |id|
        subscription_ids.include?(id)
      end
    end

    def unsubscribe_event
      {
        name: :unsubscribe,
        subscriber: subscriber,
        controller: self
      }
    end

    def resubscribe_event
      {
        name: :resubscribe,
        subscriber: subscriber,
        controller: self
      }
    end

    def publish_subscribable_events(events)
      if Feste.options[:event_subscriber].present?
        events.each do |event|
          if Feste.options[:event_subscriber].respond_to?(event[:name])
            Feste.options[:event_subscriber].public_send(event[:name], event)
          end
        end
      end
    end
  end
end
