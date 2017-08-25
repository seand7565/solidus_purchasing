module Spree
  module Admin
    class DashboardController < Spree::Admin::BaseController

      def index
        days_tracking_sales = 90
        @days_on_hand_minimum_days = 45
        vendorlist = Hash.new { |hash, key| hash[key] = {} }
        Spree::Vendor.all.each do |vendor|
          Spree::PurchasingVariant.where(:vendor_id => vendor.id).each do |pv|
            unless pv.po_line_items.where("received_amount < quantity").any? #Preventing items which are already on order from showing up
              sold = 0
              Spree::LineItem.where(:variant_id => pv.variant.id).where("created_at > ?", (Date.today - days_tracking_sales)).each do |li|
                sold += li.quantity
              end
              #If you're using assemblies, we should count those sales as well
              Spree::AssembliesPart.where(:part_id => pv.variant.id).each do |ap|
                #Because assemblies only provides a product id, I need to get the
                #variant ID. Also, I need to account for assemblies that have
                #multiple variants.
                unless ap.assembly.variants.empty?
                  id = ap.assembly.variants
                  id.each do |variant|
                    Spree::LineItem.where(:variant_id => variant.id).where("created_at > ?", (Date.today - days_tracking_sales)).each do |as|
                      sold += (as.quantity * ap.count)
                    end
                  end
                else
                  Spree::LineItem.where(:variant_id => ap.assembly.master.id).where("created_at > ?", (Date.today - days_tracking_sales)).each do |as|
                    sold += (as.quantity * ap.count)
                  end
                end

              end
              if sold > 0
                count_on_hand = pv.variant.count_on_hand
                sold_daily = sold.to_f / days_tracking_sales
                delivery_time = pv.delivery_time
                delivery_time ||= 0
                days_on_hand = ((count_on_hand / sold_daily) - delivery_time).round
                if days_on_hand < @days_on_hand_minimum_days
                  vendorlist[vendor.id][pv.variant.id] = days_on_hand
                end
              end
            end
          end
          @vendorlist = vendorlist
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
