class CreateSpreePoAdditions < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_po_additions do |t|
      t.string :text
      t.decimal :cost_price, precision: 10, scale: 5
      t.integer :quantity
      t.references :category, index: true
      t.references :purchase_order, index: true

      t.timestamps
    end
  end
end
