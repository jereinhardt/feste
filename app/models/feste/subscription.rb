module Feste
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, polymorphic: true

    before_create :generate_token

    def self.get_token_for(subscriber, mailer, action)
      transaction do
        category = mailer.action_categories[action.to_sym] || 
          mailer.action_categories[:all]
        subscription = Feste::Subscription.find_or_create_by(
          subscriber: subscriber,
          category: category
        )
        subscription.token
      end
    end

    def self.find_subscribed_user(email)
      user_models.find do |model|
        model.find_by(Feste.options[:email_source] => email)
      end&.find_by(Feste.options[:email_source] => email)
    end

    private

    def self.user_models
      @_user_models ||= Feste.options[:model_hierarchy] || included_models
    end

    def self.included_models
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