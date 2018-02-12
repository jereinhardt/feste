class TestUser
  private

  def self.find_by(**_)
    nil
  end

  def self.has_many(_, **options)
  end

  public

  include Feste::User

  @@id = 1

  def initialize(email = "test@test.com")
    @email = email
    @id = @@id

    @@id += 1
  end

  attr_accessor :email, :id
end
