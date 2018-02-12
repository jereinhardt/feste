module Feste
  class Processor
    def initialize(message, mailer, action)
      @message = message
      @mailer = mailer
      @action = action
    end

    attr_reader :message, :mailer, :action

    def process
      category_name = mailer.action_categories.keys == [:all] || 
        mailer.action_categories[action.to_sym]
      if category_name.present?
        email = message.to.first
        stop_delivery_to_unsubscribed_user!(email, category_name)
      end
    end

    private

    def stop_delivery_to_unsubscribed_user!(email, category_name)
      subscriber = Feste::Subscription.find_subscribed_user(email)
      subscription = Feste::Subscription.find_by(
        email: email,
        category_name: category_name,
        subscriber: subscriber
      )

      message.to = [] if subscription.canceled?
    end
  end
end