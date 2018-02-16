require "rails_helper"

RSpec.describe Feste::User do
  describe "#email_source" do
    it "calls the method or attribute that contains the user's email" do
      user = TestUser.new

      expect(user.email_source).to eq(user.email)
    end
  end
end