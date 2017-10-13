module Feste
  class CancelledSubscriptionsController < ActionController::Base
    before_action :given_email_matches_user?, only: [:update]
    protect_from_forgery with: :exception

    layout "feste/application"

    helper Feste::CancelledSubscriptionHelpers

    def show
      @cancelled_subscription = subscription
    end

    def update
      @cancelled_subscription = subscription
      if update_requested_changes
         @cancelled_subscription.update(cancellation_params) && 
         @cancelled_subscription.subscriber.update(user_params)
        
        redirect_to cancelled_subscription_path(subscription.token)
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

    def update_requested_changes
      @cancelled_subscription.assign_attributes(cancellation_params)
      if @cancelled_subscription.cancelled_changed? && @cancelled_subscription.cancelled
        flash[:success] = "You have successfully unsubscribed from this email notification."
      elsif @cancelled_subscription.cancelled_changed?
        flash[:success] = "You have successfully subscribed to this email notification."
      end
      @cancelled_subscription.subscriber.assign_attributes(user_params)
      if @cancelled_subscription.subscriber.cancelled_changed?
        flash[:success] ||= "You have successfully unsubscribed from all email notifications."
      else
        flash[:success] ||= "You have successfully subscribed to all email notifications."
      end
      @cancelled_subscription.subscriber.save && @cancelled_subscription.save
    end
  end
end