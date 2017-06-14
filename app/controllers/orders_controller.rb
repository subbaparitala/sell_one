class OrdersController < ApplicationController
	include ApplicationHelper
	before_filter :authenticate_user!, only: [:purchase_now]
	@@aa = []

	def new
	end

	# def save_cart
	#   order = Order.create(user_id: current_user.try(:id))  unless add_cart.present? 
	#   if add_cart.present? 
	# 	po = add_cart.product_orders.new(product_id: params[:product_id])
	#     po.save
	#   else
	#   	session[:add_to_cart] = order.id
	# 		po = order.product_orders.new(product_id: params[:product_id])
	# 		po.save
	#   end
	# end

	def purchase_now
		session[:add_to_cart] = nil
		session[:cart_products] = nil
		current_user.orders.active.update_attributes(active: false)
		redirect_to root_path
	end

	def save_cart
	  if current_user.orders.active.present? 
	  	po = current_user.orders.active.product_orders.new(product_id: params[:product_id])
	  	po.save
	  else
	  	order = Order.create(user_id: current_user.id)
	  	po = order.product_orders.new(product_id: params[:product_id])
	  	po.save
	  end
	  respond_to do |format|
        format.html{redirect_to root_path, notice: "added successfully"}
	  end
	end

	def add_to_cart
	  return save_cart if current_user.present? 
	  if add_cart.present? 
        session[:cart_products] << params[:product_id]
	  else
	  	session[:add_to_cart] = true
	  	@@aa = [] if session[:has_empty_value]
	  	@@aa << params[:product_id].to_i
	  	session[:cart_products] = @@aa.map(&:to_i)
	  end
	  respond_to do |format|
        format.html{redirect_to root_path, notice: "added successfully"}
	  end
	end

	def remove_from_cart
		if current_user.present? 
			order = Order.find(params[:order_id])
			po = order.product_orders.find_by_product_id(params[:product_id])
	  	po.destroy
	  	session[:cart_products].delete(params[:product_id]) if session[:cart_products].present?
	  end
	  redirect_to root_path
	end
end
