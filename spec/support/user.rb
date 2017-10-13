class User
  include Feste::User

  def initialize(email = "test@test.com")
    @email = email
  end

  attr_accessor :email
end
