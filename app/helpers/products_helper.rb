module ProductsHelper
	def link_for_products product
		html = ""
		add_cart = current_user.orders.active if current_user.present? 
		if ((add_cart.products.map(&:id).include?(product.id) rescue cart_products.include?(product.id)) rescue false)
		  html += link_to 'Remove', remove_from_cart_path(add_cart,product.id),method: :delete, class: 'btn btn-primary' if current_user.present? && add_cart.present? 
		   html += link_to 'Remove', remove_from_cart_path('nil',product.id),method: :delete, class: 'btn btn-primary' unless current_user.present? 
		else
			html += link_to 'Add to cart', add_to_cart_orders_path(product_id: product.id), class: 'btn btn-primary'
		  html +=	link_to 'Purchase', '', class: 'btn btn-danger'
		end
		return html.html_safe
	end
end
