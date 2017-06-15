class RegistrationsController < Devise::RegistrationsController
  
  def create
    build_resource(sign_up_params)
    if resource.save
     	if add_cart.present?
     		order = Order.new(user_id: resource.id)
     		if order.save
        	cart_products.each do |product|
         		order.product_orders.create(product_id: product) 
        	end
      	end
     	end 
    end
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
    
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    # add custom create logic here
  end



  private
  
  # def after_sign_up_path_for(resource)
  # end
  def sign_up_params
    params.require(:user).permit(:first_name,:last_name,:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name,:last_name,:email, :password, :password_confirmation)
  end
end