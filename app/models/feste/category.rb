module Feste
  class Category < ActiveRecord::Base
    has_many :subscriptions
  end
end