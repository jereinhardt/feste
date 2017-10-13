module Feste
  module CancelledSubscriptionHelpers
    UNSUBSCRIBED = "Unsubscribed".freeze
    SUBSCRIBED = "Subscribed".freeze

    def subscription_status(subscription)
      if subscription.subscriber.cancelled || subscription.cancelled
        UNSUBSCRIBED
      else
        SUBSCRIBED
      end
    end

    def subscription_status_class(subscription)
      if subscription_status(subscription) == UNSUBSCRIBED
        "color-red"
      else
        "color-green"
      end
    end

    def subscription_pluralization(subscription, singular, plural)
      if subscription.subscriber.cancelled || 
          completely_subscribed?(subscription)
        plural
      else
        singular
      end
    end

    private

    def completely_subscribed?(subscription)
      subscription.subscriber.cancelled_subscriptions.cancelled.empty? && 
        !subscription.subscriber.cancelled
    end
  end
end