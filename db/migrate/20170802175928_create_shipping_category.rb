class CreateShippingCategory < ActiveRecord::Migration[5.0]
  def change
    Spree::Category.create(:name => "Shipping")
  end
end
