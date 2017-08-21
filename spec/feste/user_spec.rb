require "spec_helper"

RSpec.describe Feste::User do
  describe ".subscriber_email_source" do
    it "sets the source of a user's email address through Feste options" do
      user = User.new

      expect(Feste.options[:email_source]).to eq(:email_address)
    end
  end

  describe "#email_source" do
    it "calls the method or attribute that contains the user's email" do
      user = User.new

      expect(user.email_source).to eq(user.email_address)
    end
  end
end