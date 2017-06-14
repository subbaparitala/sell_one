module ApplicationHelper
  def add_cart
 		order =  Order.find(session[:add_to_cart]) rescue session[:add_to_cart]
	  order = current_user.orders.active if user_signed_in?
    return order
  end
	
  def cart_products
     return session[:cart_products].map(&:to_i) rescue nil
  end

    def total_cart_products
    	return (add_cart.try(:products) || []).empty? ? total_with_session_cart_products : add_cart.products.count  rescue 0
    end

    def total_cart_price
      # add_cart.products.group('price').having('COUNT(price)')
    	return add_cart.products.collect{|k| k.price.to_f}.sum rescue total_with_session_cart_price rescue 0
    end

    def total_with_session_cart_products
     return cart_products.length
    end

    def total_with_session_cart_price
       arr = []
      cart_products.each do |product|
         arr << Product.find(product).price.to_f
      end
      return arr.sum 
    end

    def cart_products_details
      return (add_cart.try(:products) || []).empty? ? session_cart_products_details : add_cart.products
    end

    def session_cart_products_details
       return Product.where("id IN (?)", cart_products)
    end

end
