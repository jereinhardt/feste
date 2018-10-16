module Feste
  class Category < ActiveRecord::Base
    has_many :subscriptions

    validates :name, presence: true, uniqueness: true

    def self.with_mailers
      where("array_length(mailers, 1) > 0")
    end
  end
end