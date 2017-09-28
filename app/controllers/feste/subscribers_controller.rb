module Feste
  class SubscribersController < ActionController::Base
    protect_from_forgery with: :exception

    layout "feste/application"

    def show
      @subscriber = subscriber
    end

    def update
      if subscriber.update(subscriber_params)
        flash[:notice] = "Updated successfully!"
        redirect_to subscriber_path(subscriber.token)
      else
        flash[:notice] = "Something went wrong.  Please try again later."
        render :show
      end
    end

    private

    def subscriber
      Subscriber.find_by(token: params[:token])
    end

    def subscriber_params
      params.require(:subscriber).permit(:cancelled)
    end
  end
end