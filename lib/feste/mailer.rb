module Feste
  module Mailer    
    def self.included(klass)
      klass.include InstanceMethods
      klass.extend ClassMethods
      klass.send(:add_template_helper, TemplateHelper)
      klass.class_eval do
        class_attribute :action_categories
        self.action_categories = {}
      end
    end

    module InstanceMethods
      def mail(headers = {}, &block)
        if current_action_category.present?
          return message if @_mail_was_called && headers.blank? && !block

          email = headers[:to].is_a?(String) ? headers[:to] : headers[:to].first
          subscriber = headers[:subscriber] ||
            Feste::Subscription.find_subscribed_user(email)
          headers = headers.except(:subscriber)

          if recipient_subscribed?(subscriber)
            generate_subscription_token!(subscriber)
            message = super(headers, &block)
          else
            nil
          end          
        else
          super(headers, &block)
        end
      end

      private

      def current_action_category
        self.action_categories[action_name.to_sym] || 
          self.action_categories[:all]
      end

      def generate_subscription_token!(subscriber)
        @_subscription_token ||= Feste::Subscription.
          get_token_for(subscriber, self, action_name)
      end

      def recipient_subscribed?(subscriber)
        !Feste::Subscription.find_or_create_by(
          category: current_action_category,
          subscriber: subscriber
        )&.canceled?
      end
    end

    module ClassMethods
      def categorize(meths = [], as:)
        actions = meths.empty? ? [:all] : meths
        actions.each { |action| self.action_categories[action.to_sym] = as }
      end

      def action_methods
        feste_methods = %w[
          action_categories action_categories= action_categories?
        ]
        Set.new(super - feste_methods)
      end
    end
  end
end