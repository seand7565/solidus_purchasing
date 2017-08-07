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
        @purchase_order.update(params[:purchase_orders].permit(:state))
        if params[:purchase_orders][:state] == "Placed"
          Spree::Admin::VendorMailer.vendor_email(@purchase_order).deliver_now
        end
        redirect_to admin_purchase_orders_path
      end

      def receive
        line_item = Spree::PoLineItem.find(params[:line_item])
        to_add = params[:quantity]
        variant = line_item.purchasing_variant.variant
        stock_location = Spree::StockLocation.first
        stock_movement = stock_location.stock_movements.build(stock_movement_params)
        stock_movement.stock_item = stock_location.set_up_stock_item(variant)
        stock = Spree::StockItem.find_by(variant_id: variant.id).count_on_hand


          if stock_movement.save
            if params[:adjust].to_i > 0
              oldcost = variant.cost_price
              newcost = params[:newcost].to_f
              newquantity = params[:quantity].to_i
              if stock > 0 && (stock + newquantity) > 0
                costaverage = ((stock*oldcost)+(newcost*newquantity))/(stock+newquantity).round(5)
              else
                costaverage = newcost
              end
              if variant.update(cost_price: costaverage)
                flash[:success] = flash_message_for(stock_movement, :successfully_created)
                mark_received(line_item, to_add)
                redirect_to :back

              else
                flash[:error] = "Could not update cost"
              end
            else
              flash[:success] = flash_message_for(stock_movement, :successfully_created)
              mark_received(line_item, to_add)
              redirect_to :back
            end
          else
            flash[:error] = Spree.t(:could_not_create_stock_movement)
          end
      end

      private

      def mark_received(line_item, adding)
        received = line_item.received_amount.to_i + adding.to_i
        line_item.update(:received_amount => received)
        unless fully_received?(line_item.purchase_order)
          line_item.purchase_order.update(:state => "Partial")
        else
          line_item.purchase_order.update(:state => "Received")
        end
      end

      def fully_received?(purchase_order)
        line_items = purchase_order.po_line_items
        nonfull = true
        line_items.each do |line_item|
          unless line_item.received_amount == line_item.quantity
            nonfull = false
            break
          end
        end
        return nonfull
      end

      def stock_movement_params
        params.permit(permitted_stock_movement_attributes)
      end

    end
  end
end
