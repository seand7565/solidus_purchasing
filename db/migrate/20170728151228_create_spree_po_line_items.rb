class CreateSpreePoLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_po_line_items do |t|
      t.references :purchasing_variant, index: true
      t.decimal :cost_price, precision: 10, scale: 5
      t.integer :quantity
      t.references :category, index: true
      t.references :purchase_order, index: true
      t.integer :received_amount

      t.timestamps
    end
  end
end
