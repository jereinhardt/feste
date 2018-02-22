module Feste
  class Subscription < ActiveRecord::Base
    belongs_to :subscriber, polymorphic: true

    before_create :generate_token

    # Return the propper subscription token based on the propper subscriber and
    # email category
    # @param [Subscriber, ActionMailer::Base, Symbol]
    #
    # If the subscription does not exist, it creates it in order to return the
    # token.  If the action has not category, then the subscription is not
    # created, the exception is rescued, and nil is returned.
    #
    # @return [String, nil], the token or nil if a category cannot be found.
    def self.get_token_for(subscriber, mailer, action)
      begin
        category = mailer.action_categories[action.to_sym] || 
          mailer.action_categories[:all]
        subscription = Feste::Subscription.find_or_create_by(
          subscriber: subscriber,
          category: category
        )
        subscription.token
      rescue ActiveRecord::NotNullViolation
        nil
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

    # Return the human readable version of a category name.
    #
    # Checks to see if there is an i18n key corresponding to the category. If
    # not, then the category is titleized.
    #
    # @return [String]
    def category_name
      I18n.t("feste.categories.#{category}", default: category.titleize)
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