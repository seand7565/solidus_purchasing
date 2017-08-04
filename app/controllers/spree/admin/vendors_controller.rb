module Spree
  module Admin
    class VendorsController < Spree::Admin::BaseController

      def index
      end

      def new
      end

      def create
        Spree::Vendor.create(params[:vendor].permit(:name, :shipping, :send_email, :email, :alternative_email, :note, :delivery_time, :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :alternative_phone, :company, :state_id, :country_id))
        render :index
      end

      def edit
        @vendor = Spree::Vendor.find(params[:id])
      end

      def update
        Spree::Vendor.find(params[:id]).update(params[:vendor].permit(:name, :shipping, :send_email, :email, :alternative_email, :note, :delivery_time, :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :alternative_phone, :company, :state_id, :country_id))
        render :index
      end

      def destroy
        Spree::Vendor.find(params[:id]).destroy
        render :index
      end

    end
  end
end
