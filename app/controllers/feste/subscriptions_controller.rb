module Feste
  class SubscriptionsController < ActionController::Base
    before_action :given_email_matches_user?, only: [:update]
    protect_from_forgery with: :exception

    layout "feste/application"

    helper Feste::SubscriptionHelpers

    def show
      @subscription = subscription
    end

    def update
      @subscription = subscription
      if update_requested_changes
         @subscription.update(cancellation_params) && 
         @subscription.subscriber.update(user_params)
        
        redirect_to subscription_path(subscription.token)
      else
        flash[:notice] = "Something went wrong!  Please try again later."

        render :show
      end
    end

    private

    def given_email_matches_user?
      if user_params[:email].present?
        if subscription.subscriber.email != user_params[:email]
          flash[:notice] = "You do not have permission to unsubscribe from this email."
          redirect_to subscription_path(subscription.token)
        end
      else
        flash[:notice] = "Please provide an email address."
        redirect_to subscription_path(subscription.token)
      end
    end

    def subscription
      Feste::Subscription.find_by(token: params[:token])
    end

    def subscription_params
      params.require(:subscription).permit(
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

    def update_requested_changes
      @subscription.assign_attributes(cancellation_params)
      if @subscription.cancelled_changed? && @subscription.cancelled
        flash[:success] = "You have successfully unsubscribed from this email notification."
      elsif @subscription.cancelled_changed?
        flash[:success] = "You have successfully subscribed to this email notification."
      end
      @subscription.subscriber.assign_attributes(user_params)
      if @subscription.subscriber.cancelled_changed?
        flash[:success] ||= "You have successfully unsubscribed from all email notifications."
      else
        flash[:success] ||= "You have successfully subscribed to all email notifications."
      end
      @subscription.subscriber.save && @subscription.save
    end
  end
end