module Spree
  class PoAddition < ApplicationRecord
    belongs_to :category
    belongs_to :purchase_order
  end
end
