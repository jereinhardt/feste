require "rails_helper"

RSpec.describe Feste::SubscriptionsController, type: :controller do
  routes { Feste::Engine.routes }

  describe "#index" do
    context "when being accessed without a token" do
      it "returns a 404 response to unauthroized users" do
        get :index

        expect(response.status).to eq 404
      end
    end
  end

  describe "#update" do
    before do
      class EventSubscriber
        def unsubscribe(event); end
        def resubscribe(event); end
      end

      Feste.configure do |config|
        config.event_subscriber = EventSubscriber.new
      end
    end

    after do
      Feste.configure do |config|
        config.event_subscriber = nil
      end
    end

    context "when being accessed without a token" do
      it "returns a 404 resopnse to unauthroized users" do
        put :update, params: { user: { subscriptions: "" } }

        expect(response.status).to eq 404
      end
    end

    context "when a user unsubscribes" do
      it "triggers the unsubscribe listener" do
        expect_any_instance_of(EventSubscriber).to receive(:unsubscribe)

        subscriber = create(:user)
        create_subscriptions_list_for(subscriber)
        token = subscriber.subscriptions.last.token

        put :update, params: { token: token, user: { subscriptions: "" } }
      end
    end

    context "when a user resubscribes" do
      it "triggers the resubscribe listener" do
        expect_any_instance_of(EventSubscriber).to receive(:resubscribe)

        subscriber = create(:user)
        create_subscriptions_list_for(
          subscriber,
          canceled: true
        )
        subscription_ids = subscriber.subscriptions.map(&:id)
        token = subscriber.subscriptions.last.token

        put(
          :update,
          params: { token: token, user: { subscriptions: subscription_ids } }
        )
      end
    end

    context "when a user resubscribes and unsubscribes" do
      it "sends the unsubscribe and resubscribe " do
        expect_any_instance_of(EventSubscriber).to receive(:unsubscribe)
        expect_any_instance_of(EventSubscriber).to receive(:resubscribe)

        subscriber = create(:user)
        create_subscriptions_list_for(subscriber)
        subscriber.subscriptions.first.update(canceled: true)
        sub_ids = [
          subscriber.subscriptions.where(canceled: false).first.id,
          subscriber.subscriptions.where(canceled: true).first.id
        ]
        token = subscriber.subscriptions.last.token

        put :update, params: { token: token, user: { subscriptions: sub_ids } }
      end
    end
  end

  def create_subscriptions_list_for(subscriber, options = {})
    Feste.options[:categories].map do |cat|
      create(
        :subscription,
        { subscriber: subscriber, category: cat }.merge(options)
      )
    end
  end
end