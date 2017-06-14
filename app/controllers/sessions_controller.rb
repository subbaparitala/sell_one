class SessionsController < Devise::SessionsController 
  def new
    begin
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    rescue 
      redirect_to root_path
      flash[:errors] = "Invalid user email or password"
    end
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    if add_cart.present?
      if resource.orders.active.present? 
      product_orders = resource.orders.active.product_orders.map(&:id).length > cart_products.count ? get_product_orders : get_product_orders_session
        product_orders.each do |product|
          resource.orders.active.product_orders.find_or_create_by(product_id: product) 
        end
      else
        if resource.orders.new().save
          cart_products.each do |product|
            resource.orders.active.product_orders.find_or_create_by(product_id: product)
          end
        end
      end
      session[:has_empty_value] = true
      session[:cart_products] = nil
      session[:add_cart]=nil
    end

    yield resource if block_given?
    respond_with resource, location: root_path
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
    session[:has_empty_value] = true
    session[:cart_products] = nil
    session[:add_cart]=nil
  end

  def get_product_orders
    resource.orders.active.product_orders.map(&:product_id) - cart_products
  end

  def get_product_orders_session
    cart_products - resource.orders.active.product_orders.map(&:product_id)
  end

  

  protected
  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def translation_scope
    'devise.sessions'
  end

  private

  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end
