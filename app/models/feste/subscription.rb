module Feste
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, polymorphic: true
    # For now, the association to a category is allowed to be optional as a
    # contengency for applications that upgraded from 0.3.0 to 0.4.0.  This will
    # be set to false in 1.0
    belongs_to :category, optional: true

    before_create :generate_token

    delegate :name, to: :category, prefix: true

    # Return the proper subscription token based on the proper subscriber and
    # email category
    # @param [Subscriber, ActionMailer::Base, Symbol]
    #
    # If the subscription does not exist, one is created in order to return the
    # token.  If the action is not categorized, then the subscription is not
    # created, and nil is returned.
    #
    # @return [String, nil], the token or nil if a category cannot be found.
    def self.get_token_for(subscriber, category)
      transaction do
        subscription = Feste::Subscription.find_or_create_by(
          subscriber: subscriber,
          category: category
        )
        subscription.token
      end
    end

    # Return the subscriber based on an email address
    # @param [String]
    #
    # @return [Subscriber, nil], the subscriber if one exists, or nil if none
    # exists
    def self.find_subscribed_user(email)
      user_models.find do |model|
        model.find_by(Feste.options[:email_source] => email)
      end&.find_by(Feste.options[:email_source] => email)
    end

    private

    def self.user_models
      ActiveRecord::Base.descendants.select do |klass|
        klass.included_modules.include?(Feste::User)
      end
    end

    def generate_token
      if !self.token
        self.token = Base64.
          urlsafe_encode64("#{category}|#{subscriber_id}|#{subscriber_type}")
      end
    end
  end
end