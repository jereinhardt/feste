module Feste
  class Category < ActiveRecord::Base
    has_many :subscriptions, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    # Returns all categories that have at least one mailer assigned to them.
    #
    # @return ActiveRecord::Relation
    def self.with_mailers
      where("array_length(mailers, 1) > 0")
    end

    # Returns the category that has the given mailer assigned to it.  If no 
    # category exists, returns nil.
    #
    # @return [Category, nil]
    def self.find_by_mailer(mailer)
      where("mailers @> '{#{mailer}}'::text[]").first
    end
  end
end