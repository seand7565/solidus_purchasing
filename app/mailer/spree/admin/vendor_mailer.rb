module Spree
  module Admin
    class VendorMailer < BaseMailer

      def vendor_email(vendor, number)
        #attachments['po_#{vendor.name}_#{@purchase_order.created_at.to_date}.pdf'] =
        #  File.read()
        mail(to: vendor.email, subject: "Puchase Order")
      end

    end
  end
end
