module Feste
  class Processor
    def initialize(message, mailer, action, user)
      @message = message
      @mailer = mailer
      @action = action
      @user = user
    end

    attr_reader :message, :mailer, :action, :user

    def process
      if mailer.class.feste_whitelist.any?
        return true unless mailer.class.feste_whitelist.include?(action)
      elsif mailer.class.feste_blacklist.any?
        return true if mailer.class.feste_blacklist.include?(action)
      end
      stop_delivery_to_unsubscribed_user!
    end

    private

    def stop_delivery_to_unsubscribed_user!
      subscriber = Feste::Subscriber.find_or_create_by(email: user.email_source)
      if subscriber.cancelled
        message.to = []
        return true
      end
      email = Feste::Email.
        find_or_create_by(mailer: mailer.class.name, action: action.to_s)
      cancellation = Feste::CancelledSubscription.
        find_or_create_by(subscriber: subscriber, email: email)
      message.to = [] if cancellation.cancelled
    end
  end
end