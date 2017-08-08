module Spree
  module Admin
    class PoAdditionsController < Spree::Admin::BaseController

      def create
        Spree::PoAddition.create(params[:po_addition].permit(:category_id, :text, :quantity, :cost_price, :purchase_order_id))
        redirect_back(fallback_location: root_path)
      end

      def destroy
        Spree::PoAddition.find(params[:id]).destroy
        redirect_back(fallback_location: root_path)
      end

      def edit
        @addition = Spree::PoAddition.find(params[:id])
      end

      def update
        Spree::PoAddition.find(params[:id]).update(params[:addition].permit(:category_id, :text, :quantity, :cost_price))
        purchase_order = Spree::PoAddition.find(params[:id]).purchase_order
        redirect_to edit_admin_purchase_order_path(purchase_order)
      end

    end
  end
end
