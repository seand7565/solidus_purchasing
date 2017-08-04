class CreateSpreePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_purchase_orders do |t|
      t.string :number
      t.string :state, default: "Pending"
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
