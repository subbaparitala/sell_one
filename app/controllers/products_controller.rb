class ProductsController < ApplicationController
	before_action :find_product, only: [:edit,:show,:update,:destroy]
	def new
		@product = Product.new
	end

	def create
		product = Product.new(product_params)
	 	respond_to do |format|
      if product.save
      	params[:product][:category_ids].each do |category_id|
      		product.product_categories.create(category_id: category_id)
      	end
        format.html {redirect_to new_product_path, notice: "Sucessfully created the question"}
      else
        format.html { redirect_to product_path(product), notice: "Enter description and answer" }
      end
    end
	end

	def edit
	end

	def show
	end

	def update
	end
  

	def destroy
	end
  
  def find_product
   @product = Product.find(params[:id])
  end
	private
	def product_params
		 params.require(:product).permit(:name,:description,:price,:product_img)
	end
end
