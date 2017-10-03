class CreateVendorLists < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_vendor_lists do |t|
      t.string :list

      t.timestamps
    end
  end
end
