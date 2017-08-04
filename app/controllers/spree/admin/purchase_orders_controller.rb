module Spree
  module Admin
    class PurchaseOrdersController < Spree::Admin::BaseController

      def index
        @purchase_orders = Spree::PurchaseOrder.all.order('created_at DESC')
      end

      def new

      end

      def show
        @purchase_order = Spree::PurchaseOrder.find(params[:id])
        @ship_to = Spree::StockLocation.first
        render :partial => 'pdf'
      end

      def create
        @purchase_order = Spree::PurchaseOrder.create(params[:purchase_order].permit(:vendor_id, :number))
        redirect_to edit_admin_purchase_order_path(@purchase_order)
      end

      def edit
        @purchase_order = Spree::PurchaseOrder.find(params[:id])
        @vendor = @purchase_order.vendor
        @ship_to = Spree::StockLocation.first
      end

      def destroy
        Spree::PurchaseOrder.find(params[:id]).destroy
        redirect_to :back
      end

      def update
        @purchase_order = Spree::PurchaseOrder.find(params[:id])
        #Spree::PurchaseOrder.find(params[:id]).update(params[:purchase_orders].permit(:state))
        if params[:purchase_orders][:state] == "Placed"
          Spree::Admin::VendorMailer.vendor_email(@purchase_order.vendor, @purchase_order.number).deliver_now
        end
        #redirect_to admin_purchase_orders_path
        redirect_to :back
      end

    end
  end
end
