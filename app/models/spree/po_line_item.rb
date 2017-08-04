module Spree
  class PoLineItem < ApplicationRecord
    belongs_to :purchasing_variant
    belongs_to :category
    belongs_to :purchase_order
  end
end
