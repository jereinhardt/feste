module Feste
  class Processor
    def initialize(message, mailer, action)
      @message = message
      @mailer = mailer
      @action = action
    end

    attr_reader :message, :mailer, :action

    def process
      category = mailer.action_categories[:all] || 
        mailer.action_categories[action.to_sym]
      if category.present?
        email = message.to.first
        stop_delivery_to_unsubscribed_user!(email, category)
      end
    end

    private

    def stop_delivery_to_unsubscribed_user!(email, category)
      subscriber = Feste::Subscription.find_subscribed_user(email)
      subscription = Feste::Subscription.find_by(
        category: category,
        subscriber: subscriber
      )

      message.to = [] if subscription.canceled?
    end
  end
end