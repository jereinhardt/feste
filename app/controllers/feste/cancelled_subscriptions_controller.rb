module Feste
  class CancelledSubscriptionsControllers < ActionController::Base
    protect_from_forgery with: :exception

    layout "feste/application"

    def show
      @cancelled_subscription = subscription
    end

    def update
      if subscription.update(cancellation_params) && 
        subject.update(user_params) &&
        given_email_matches_user?
        
        render :show
      else
        redirect_to feste_cancelled_subscription_path(subscription.token)
      end
    end

    private

    def given_email_matches_user?
      if user_params[:email].present?
        if subscription.user.email == user_params[:email]
          return true
        else
          flash[:notice] = "You do not have permission to unsubscribe from this email."
          return false
        end
      else
        flash[:notice] = "Please provide an email address."
        return false
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