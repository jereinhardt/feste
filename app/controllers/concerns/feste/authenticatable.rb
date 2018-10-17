module Feste
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      if Feste.options[:authenticate_with] == :clearance
        include Feste::Authentication::Clearance
      elsif Feste.options[:authenticate_with] == :devise
        include Feste::Authentication::Devise
      elsif Feste.options[:authenticate_with].is_a?(Proc)
        include Feste::Authentication::Custom
      else
        include Feste::Authentication::DefaultInstanceMethods
      end

      before_action :get_user_data
    end

    def subscriber
      @_subscriber ||= Feste::Subscription.find_by(token: params[:token])&.subscriber ||
        current_user
    end

    def get_user_data
      if subscriber.present?
        find_or_create_subscriptions
      else
        render file: "#{Rails.root}/public/404.html",  status: 404
      end
    end

    def find_or_create_subscriptions
      Feste::Category.with_mailers.each do |category|
        Feste::Subscription.find_or_create_by(
          subscriber: subscriber,
          category: category
        )
      end
    end
  end
end