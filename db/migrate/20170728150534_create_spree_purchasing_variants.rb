class CreateSpreePurchasingVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_purchasing_variants do |t|
      t.string :manufacturer_id
      t.decimal :cost_price, precision: 10, scale: 5
      t.boolean :dropship
      t.integer :delivery_time
      t.references :vendor, index: true
      t.integer :multiples
      t.integer :minimum
      t.references :category, index: true
      t.references :variant, index: true
      t.boolean :orderable

      t.timestamps
    end
  end
end
