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
    context "when being accessed without a token" do
      it "returns a 404 resopnse to unauthroized users" do
        put :update, params: { user: { subscriptions: [] } }

        expect(response.status).to eq 404
      end
    end
  end
end