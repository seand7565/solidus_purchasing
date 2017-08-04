module Spree
  class PurchaseOrder < ApplicationRecord
    belongs_to :vendor
    has_many :po_line_items, :dependent => :destroy
    has_many :po_additions, :dependent => :destroy


  end
end
