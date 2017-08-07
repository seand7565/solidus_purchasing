module Spree
  module Admin
    class DashboardController < Spree::Admin::BaseController

      def index
        Spree::Vendor.all.each do |vendor|
          Spree::PurchasingVariant.where(:vendor_id => vendor.id).each do |pv|
            sold = 0
            Spree::LineItem.where(:variant_id => pv.variant.id).where(:order => {"completed_at > ?" => (Date.today-90)}).each do |li|
              p li
            end

          end
        end

      end


    end
  end
end
