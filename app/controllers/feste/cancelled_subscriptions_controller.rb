module Feste
  class CancelledSubscriptionsController < ActionController::Base
    before_action :given_email_matches_user?, only: [:update]
    protect_from_forgery with: :exception

    layout "feste/application"

    def show
      @cancelled_subscription = subscription
    end

    def update
       @cancelled_subscription = subscription
      if @cancelled_subscription.update(cancellation_params) && 
         @cancelled_subscription.subscriber.update(user_params)
        
        redirect_to cancelled_subscription_path(subscription.token)
      else
        render :show
      end
    end

    private

    def given_email_matches_user?
      if user_params[:email].present?
        if subscription.subscriber.email != user_params[:email]
          flash[:notice] = "You do not have permission to unsubscribe from this email."
          redirect_to cancelled_subscription_path(subscription.token)
        end
      else
        flash[:notice] = "Please provide an email address."
        redirect_to cancelled_subscription_path(subscription.token)
      end
    end

    def subscription
      Feste::CancelledSubscription.find_by(token: params[:token])
    end

    def subscription_params
      params.require(:cancelled_subscription).permit(
        :cancelled,
        subscriber: [:cancelled, :email]
      )
    end

    def cancellation_params
      subscription_params.except(:subscriber)
    end

    def user_params
      subscription_params[:subscriber].compact
    end
  end
end