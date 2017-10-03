#-----------------------------------------
# generate dashboard info
#
# generates info for the purchasing dashboard on command
# this query takes too long on its own to be a part
# of the controller
#
#-----------------------------------------

desc 'Generates dashboard info for purchasing'
task :generate_dashboard_info => :environment do |t, args|
  p "Generating dashboard info..."
  days_tracking_sales = 90
  @days_on_hand_minimum_days = 45
  vendorlist = Hash.new { |hash, key| hash[key] = {} }
  Spree::Vendor.all.each do |vendor|
    Spree::PurchasingVariant.where(:vendor_id => vendor.id).each do |pv|
      unless pv.po_line_items.where("COALESCE(received_amount, 0) < quantity").any? #Preventing items which are already on order from showing up
        sold = 0
        Spree::LineItem.joins(:order).where(:variant_id => pv.variant.id).where("spree_orders.created_at > ?", (Date.today - days_tracking_sales)).where("spree_orders.state = ?", "complete").each do |li|
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
              Spree::LineItem.joins(:order).where(:variant_id => variant.id).where("spree_orders.created_at > ?", (Date.today - days_tracking_sales)).where("spree_orders.state = ?", "complete").each do |as|
                sold += (as.quantity * ap.count)
              end
            end
          else
            Spree::LineItem.joins(:order).where(:variant_id => ap.assembly.master.id).where("spree_orders.created_at > ?", (Date.today - days_tracking_sales)).where("spree_orders.state = ?", "complete").each do |as|
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

  end
  vl = Spree::VendorList.new
  vl.list = vendorlist
  vl.save!
  p "Dashboard info generated"
end
