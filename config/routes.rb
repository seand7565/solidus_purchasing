Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors do
      post :create
    end

    resources :purchasing_variants

    resources :categories

    resources :purchase_orders

    resources :po_line_items

    resources :po_additions
  end
end
