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
      # Returns a Mail object or nil based on if the action has been categorized
      # and if the subscriber is unsubscribed
      # @param [Hash, &block]
      #
      # The subscriber is supplied as an argument in the headers through the as
      # :subscriber key. The :subscriber key is stripped from the headers before
      # they are given as an argument to the superclass.  If no subscriber is
      # provided, then one will be inferred from the :to header.
      #
      # @return [Mail, nil], the Mail object or nil if the subscriber is
      # unsubscribed
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
      # Assign action(s) to a category
      # @param [Array, Symbol]
      #
      # The actions in the mailer that are included in the given category can be
      # limited by listing them in an array of symbols.
      #
      #     categorize [:send_reminder, :send_update], as: :reminder_emails
      #
      # If no array is provided all action in the mailer will be categorized.
      #
      #     categorize as: :reminder_emails
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