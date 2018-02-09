require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#email_source" do
    it "returns the user's email" do
      user = create(:user)

      expect(user.email_source).to eq(user.email)
    end
  end
end
