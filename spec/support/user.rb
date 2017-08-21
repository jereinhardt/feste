class User
  include Feste::User

  subscriber_email_source :email_address

  def initialize(email = "test@test.com")
    @email_address = email
  end

  attr_accessor :email_address
end
