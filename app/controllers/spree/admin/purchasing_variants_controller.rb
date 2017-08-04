module Spree
  module Admin
    class PurchasingVariantsController < Spree::Admin::BaseController

      def show
        @product = Spree::Product.find_by(:slug => params[:id])
        @variants = @product.variants
        @variants_including_master = @product.variants_including_master
      end

      def create
        Spree::PurchasingVariant.create(params[:purchasing_variant].permit(:orderable, :dropship, :manufacturer_id, :cost_price, :delivery_time, :multiples, :minimum, :variant_id, :vendor_id, :category_id))
      end

      def update
        Spree::PurchasingVariant.find(params[:id]).update(params[:purchasing_variant].permit(:orderable, :dropship, :manufacturer_id, :cost_price, :delivery_time, :multiples, :minimum, :variant_id, :vendor_id, :category_id))
      end

    end
  end
end
