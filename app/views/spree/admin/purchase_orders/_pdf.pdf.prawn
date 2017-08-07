require 'prawn/layout'

#document vars
@max_first_page_items = 20
@max_additional_page_items = 30

#text fills
@document_type_fill = "E99323"
@default_fill = "000000"
@spec_instr_fill = "990000"


#-----------
bounding_box([bounds.left, cursor], width: bounds.right) do
  image Rails.root.join(Spree::PrintInvoice::Config[:print_invoice_logo_path]), at: [bounds.left, bounds.top]
  #----------- DOCUMENT HEADER
  doc_type_settings     = { align: :right, style: :bold, size: 18 }
  order_num_settings    = { align: :right, style: :bold, size: 18}
  completed_settings    = { align: :right, size: 9 }

  fill_color @document_type_fill
  fill_color @default_fill

  move_down 4
  text "Purchase Order", order_num_settings
  header_table_data = [
    ["Date", "Number"],["#{@purchase_order.created_at.to_date}", "#{@purchase_order.number}"]
  ]
  table(header_table_data, :width => 135, :cell_style => { size: 9 }, :position => :right) do
  end

  #---------- ADDRESS
  vendor_address        = @purchase_order.vendor
  location_address      = @ship_to

  move_down 20

  title_table_data = [
    [vendor_address.name, "Ship To"]
  ]

  table(title_table_data, :width => 540, :cell_style => { size: 9 }) do
    row(0).font_style = :bold

    #Billing address header
    row(0).column(0).borders = [:bottom]
    row(0).column(0).border_width = 0.5
    row(0).column(0).padding = [2, 6]
    row(0).column(0).border_style = :underline_header

    #Shipping address header
    row(0).column(1).borders = [:bottom]
    row(0).column(1).border_widths = 0.5
    row(0).column(1).padding = [2, 6]
    row(0).column(1).border_style = :underline_header
  end

  move_down 2


  address_data = [["#{vendor_address.firstname} #{vendor_address.lastname}", "#{location_address.name}"],
                  [vendor_address.address1, location_address.address1]]
  address_data << [vendor_address.address2, location_address.address2] unless
    vendor_address.address2.blank? and location_address.address2.blank?
  address_data << ["#{vendor_address.zipcode} #{vendor_address.city} #{(vendor_address.state ? vendor_address.state.abbr : "")} ",
                  "#{location_address.zipcode} #{location_address.city} #{(location_address.state ? location_address.state.abbr : "")}"]
  address_data << [vendor_address.country.name, location_address.country.name]
  address_data << ["Phone: #{number_to_phone(vendor_address.phone)}", "Phone: #{number_to_phone(location_address.phone)}"]


  table(address_data, :width => 540, :cell_style => { size: 9 }) do

    #Vendor address
    column(0).border_widths = 0
    column(0).padding = [0, 6]

    #Location address
    column(1).border_widths = 0
    column(1).padding = [0, 6]
  end
  move_down 20

  #----------- HEADER

  data = []

  @column_widths      = { 0 => 100, 1 => 295, 2 => 40, 3 => 40, 4 => 65 }
  data << ["Category", "Description", "Qty", "Rate", "Total"]

  table(data, :width => 540, :cell_style => { size: 9 }, column_widths: @column_widths) do
    row(0).font_style = :bold
    row(0).border_width = 1
    row(0).padding = [2,6]
    row(0).column(0).align = :left
    row(0).column(1).align = :left
    row(0).column(2).align = :left
    row(0).column(3).align = :right
    row(0).column(4).align = :right
  end
  move_down 4

  #------------- LINE ITEMS

  line_items = @purchase_order.po_line_items + @purchase_order.po_additions
  if line_items.empty?
    text "Line items are not available"
    move_down 20
  else
    @widths      = { 0 => 100, 1 => 295, 2 => 40, 3 => 40, 4 => 65 }
    move_down 2
    pdf_line_items = []
    line_items.first(@max_first_page_items).each do |item|
      row = []
      row << item.category.name
      unless item.respond_to? :purchasing_variant
        row << item.text.to_s
      else
        row << item.purchasing_variant.name.to_s
      end
      row << item.quantity.to_i
      row << Spree::Money.new(item.cost_price).to_s
      row << Spree::Money.new(item.quantity * item.cost_price).to_s
      pdf_line_items << row
    end
    table(pdf_line_items, :width => 540, :cell_style => { size: 9 }, column_widths: @widths) do
      if cells.row_count > 1 then
        cells.borders = [:left, :right]
        row(0).borders = [:top, :left, :right]
        row(-1).borders = [:left, :right, :bottom]
      else
        cells.borders = [:left, :right, :top, :bottom]
      end
      cells.border_widths = 0.5
      cells.padding = [5,6]
      column(0).align = :left
      column(1).align = :left
      column(2).align = :left
      column(3).align = :right
      column(4).align = :right
    end
    #------------ ADDITIONAL PAGES
    if line_items.count > @max_first_page_items
      additional_pages = ((line_items.count - @max_first_page_items) / @max_additional_page_items.to_f).ceil
      printed = @max_first_page_items
      additional_pages.times do
        start_new_page
        #------------ HEADER
        data = []

        @column_widths      = { 0 => 100, 1 => 295, 2 => 40, 3 => 40, 4 => 65 }
        data << ["Category", "Description", "Qty", "Rate", "Total"]

        table(data, :width => 540, :cell_style => { size: 9 }, column_widths: @column_widths) do
          row(0).font_style = :bold
          row(0).border_width = 1
          row(0).padding = [2,6]
          row(0).column(0).align = :left
          row(0).column(1).align = :left
          row(0).column(2).align = :left
          row(0).column(3).align = :right
          row(0).column(4).align = :right
        end
        move_down 4
        #------------ LINE ITEMS
        @widths      = { 0 => 100, 1 => 295, 2 => 40, 3 => 40, 4 => 65 }
        move_down 2
        pdf_line_items = []
        line_items[printed...(printed + @max_additional_page_items)].each do |item|
          row = []
          row << item.category.name
          unless item.respond_to? :purchasing_variant
            row << item.text.to_s
          else
            row << item.purchasing_variant.name.to_s
          end
          row << item.quantity.to_i
          row << Spree::Money.new(item.cost_price).to_s
          row << Spree::Money.new(item.quantity * item.cost_price).to_s
          pdf_line_items << row
        end
        table(pdf_line_items, :width => 540, :cell_style => { size: 9 }, column_widths: @widths) do
          if cells.row_count > 1 then
            cells.borders = [:left, :right]
            row(0).borders = [:top, :left, :right]
            row(-1).borders = [:left, :right, :bottom]
          else
            cells.borders = [:left, :right, :top, :bottom]
          end
          cells.border_widths = 0.5
          cells.padding = [5,6]
          column(0).align = :left
          column(1).align = :left
          column(2).align = :left
          column(3).align = :right
          column(4).align = :right
        end
        printed += @max_additional_page_items
      end
    end
  end
  #------------ SUMMARY

  summary = []
  total = 0
  line_items.each do |item|
    total += item.quantity * item.cost_price
  end
  summary << ["Total", Spree::Money.new(total).to_s]

  @widths = { 0 => 465, 1 => 75 }
  table(summary, :width => 540, :cell_style => { size: 9 }, column_widths: @widths) do
    cells.border_width = 0
    cells.padding = [2,6]
    column(0).align = :right
    column(1).align = :right
    row(0).font_style = :bold
    row(-1).font_style = :bold
  end
end
