module Spree
  module Admin
    class PoLineItemsController < Spree::Admin::BaseController

      def create
        Spree::PoLineItem.create(params[:po_line_item].permit(:category_id, :purchasing_variant_id, :quantity, :cost_price, :purchase_order_id))
        redirect_to :back
      end

      def destroy
        Spree::PoLineItem.find(params[:id]).destroy
        redirect_to :back
      end

      def edit
        @line_item = Spree::PoLineItem.find(params[:id])
        @vendor = @line_item.purchasing_variant.vendor
      end

      def update
        Spree::PoLineItem.find(params[:id]).update(params[:line_item].permit(:category_id, :purchasing_variant_id, :quantity, :cost_price))
        purchase_order = Spree::PoLineItem.find(params[:id]).purchase_order
        redirect_to edit_admin_purchase_order_path(purchase_order)
      end

    end
  end
end
