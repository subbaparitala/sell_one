class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	def add_cart
 		return Order.find(session[:add_to_cart]) rescue session[:add_to_cart]
	end
	
	def cart_products
     return session[:cart_products].map(&:to_i) rescue nil
  end
end
