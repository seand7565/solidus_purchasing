module Spree
  module Admin
    class CategoriesController < Spree::Admin::BaseController

      def index

      end

      def create
        Spree::Category.create(params[:categories].permit(:name))
        render :index
      end

      def destroy
        Spree::Category.find(params[:id]).destroy
        render :index
      end

    end
  end
end
