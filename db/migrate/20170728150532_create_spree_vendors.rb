class CreateSpreeVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_vendors do |t|
      t.string :name
      t.string :shipping
      t.boolean :send_email
      t.string :note
      t.integer :delivery_time
      t.string :firstname
      t.string :lastname
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :phone
      t.references :state, index: true
      t.references :country, index: true
      t.string :alternative_phone
      t.string :company
      t.string :email
      t.string :alternative_email

      t.timestamps
    end
  end
end
