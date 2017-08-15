module Feste
  class Processor
    def initialize(message, mailer, action)
      @message = message
      @mailer = mailer
      @action = action
    end

    attr_reader :message, :mailer, :action

    def process
      if mailer.class.feste_whitelist.any?
        return true unless mailer.class.feste_whitelist.include?(action)
      elsif mailer.class.feste_blacklist.any?
        return true if mailer.class.feste_blacklist.include?(action)
      end
      stop_delivery_to_unsubscribed_emails!
    end

    private

    def stop_delivery_to_unsubscribed_emails!
      message.to.each do |email|
        message.to.delete(email) if unsubscibed_email?(email)
      end
    end

    def unsubscibed_email?(email)
      sub = Subscriber.find_or_create_by(email: email)
      return true if sub.cancelled
      Feste::CancelledSubscription.cancellation_exists?(
        subscriber: sub, 
        mailer: mailer.class.name,
        action: action.to_s
      )
    end
  end
end