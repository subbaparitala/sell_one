Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations', sessions: 'sessions'}
  root 'welcome#index'

  match '/orders/:order_id/remove_from_cart/:product_id' => 'orders#remove_from_cart', via: :delete,as: :remove_from_cart

  namespace :api, defaults: { format: :json }  do
  	scope module: :v1 do
    	get '/get_products' =>'orders#get_products', as: :get_products
    	get '/get_orders' =>'orders#get_orders', as: :get_orders
  	end
	end

  resources :orders do
    collection do
    	get 'add_to_cart'
    end
    member do 
      get 'purchase_now'
    end
  end
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
