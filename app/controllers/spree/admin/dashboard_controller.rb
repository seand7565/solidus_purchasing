module Spree
  module Admin
    class DashboardController < Spree::Admin::BaseController

      def index
        @days_on_hand_minimum_days = 20
        unless Spree::VendorList.last.nil?
          @vendorlist = eval(Spree::VendorList.last.list)
          @date = Spree::VendorList.last.created_at
        else
          @vendorlist = {}
          @date = "Nilch"
        end
      end

      def create
        po = Spree::PurchaseOrder.new
        vendor = Spree::Vendor.find(params[:dashboard][:vendor_id])
        po.vendor_id = params[:dashboard][:vendor_id]
        po.number = rand(8 ** 8)
        po.state = "Pending"
        if po.save!
          params[:dashboard][:variants].each do |variant, quantity|
            pv = Spree::PurchasingVariant.find_by(:variant_id => variant)
            po_li = Spree::PoLineItem.new
            po_li.purchase_order_id = po.id
            po_li.category_id = pv.category_id
            po_li.cost_price = pv.cost_price || 0
            po_li.quantity = quantity
            po_li.purchasing_variant_id = pv.id
            po_li.save!
          end
          ship = Spree::PoAddition.new
          ship.text = vendor.shipping
          ship.cost_price = 0
          ship.quantity = 1
          ship.category_id = 1
          ship.purchase_order_id = po.id
          ship.save!
        end
        redirect_to edit_admin_purchase_order_path(po.id)
      end


    end
  end
end
