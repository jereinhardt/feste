require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it do 
      is_expected.to have_many(:subscriptions).class_name("Feste::Subscription")
    end
  end

  describe "#email_source" do
    it "returns the user's email" do
      user = create(:user)

      expect(user.email_source).to eq(user.email)
    end
  end

  describe ".active_subscriptions" do
    it "returns subscriptions with a category" do
      user = create(:user)

      sub_with_category = create(:subscription, subscriber: user)
      sub_without_category = create(
        :subscription,
        subscriber: user,
        category: nil
      )
      result = user.active_subscriptions

      expect(result).to include(sub_with_category)
      expect(result).not_to include(sub_without_category)
    end
  end
end
