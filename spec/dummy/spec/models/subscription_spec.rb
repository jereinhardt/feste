require "rails_helper"

RSpec.describe Feste::Subscription, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:subscriber) }
    it { is_expected.to belong_to(:category) }
  end

  describe ".get_token_for" do
    context "when the subscription exists" do
      it "returns the token for the subscription" do
        user = create(:user)

        subscription = create(
          :subscription,
          subscriber: user
        )

        token = Feste::Subscription.get_token_for(
          user,
          subscription.category
        )

        expect(token).to eq(subscription.token)
      end
    end

    context "when the subscription does not exist" do
      it "creates a subscription and returns its token" do
        user = create(:user)
        category = create(:category)

        token = Feste::Subscription.get_token_for(
          user,
          category
        )

        subscription = Feste::Subscription.find_by(
          subscriber: user,
          category: category
        )

        expect(subscription.token).to eq(token)
      end
    end
  end

  describe ".find_subscribed_user" do
    it "returns the application's user record that matches the given email" do
      user = create(:user)

      result = Feste::Subscription.find_subscribed_user(user.email)

      expect(result).to eq(user)
    end
  end
end