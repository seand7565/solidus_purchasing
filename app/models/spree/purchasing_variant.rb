module Spree
  class PurchasingVariant < ApplicationRecord
    belongs_to :vendor
    belongs_to :category
    belongs_to :variant

    def name
      unless self.manufacturer_id.empty?
        return "#{self.variant.sku} - #{self.manufacturer_id} - #{self.variant.name}"
      else
        return "#{self.variant.sku} - #{self.variant.name}"
      end
    end
  end
end
