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
        if process_current_action?
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

      def process_current_action?
        self.action_categories[action_name.to_sym] || 
          self.action_categories[:all]
      end

      def generate_subscription_token!(subscriber)
        @_subscription_token ||= Feste::Subscription.
          get_token_for(subscriber, self, action_name)
      end

      def recipient_subscribed?(subscriber)
        if subscriber.present?
          category = self.action_categories[action_name.to_sym] ||
            self.action_categories[:all]
          !Feste::Subscription.find_or_create_by(
            category: category,
            subscriber: subscriber
          ).canceled?
        else
          false
        end
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