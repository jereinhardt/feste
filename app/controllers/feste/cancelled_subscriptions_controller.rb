module Feste
  class CancelledSubscriptionsControllers < ActionController::Base
    def show
      @subscription = subscription
    end

    def update
      @subscription = subscription
      subject = if params[:unsubscribe_user].present?
                  @subscription.user
                else
                  @subscription
                end

      if subject.update(cancelled: true)
        render :show
      else
        redirect_to feste_cancelled_subscription_path(@subscription.token)
      end
    end

    private

    def subscription
      Feste::CancelledSubscription.find_by(token: params[:token])
    end

    def supscription_params
      params.require(:cancelled_subscription).permit(:cancelled)
    end
  end
end