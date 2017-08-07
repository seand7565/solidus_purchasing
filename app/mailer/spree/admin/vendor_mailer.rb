module Spree
  module Admin
    class VendorMailer < BaseMailer

      def vendor_email(po)
        @purchase_order = po
        attachments["po_#{po.number}.pdf"] = generate_pdf(po)
        mail(to: po.vendor.email, cc: po.vendor.alternative_email, from: Spree::Store.default.mail_from_address, subject: "Puchase Order #{po.number}")
      end

      def generate_pdf(po)
        @purchase_order = po
        @ship_to = Spree::StockLocation.first
        render :partial => 'spree/admin/purchase_orders/pdf'
      end

    end
  end
end
