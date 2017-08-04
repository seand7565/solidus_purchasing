Spree::Backend::Config.configure do |config|
  config.menu_items << config.class::MenuItem.new(
    [:purchase_orders],
    'money',
    partial: 'spree/admin/shared/purchasing_sub_menu'
  )
end
