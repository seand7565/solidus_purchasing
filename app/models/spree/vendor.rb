module Spree
  class Vendor < ApplicationRecord
    belongs_to :state
    belongs_to :country

    validates :name, presence: true, uniqueness: true
  end
end
