module Spree
  class Vendor < ApplicationRecord
    belongs_to :state
    belongs_to :country
    has_many :purchase_orders

    validates :name, presence: true, uniqueness: true
  end
end
