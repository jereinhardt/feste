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
end
