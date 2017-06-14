class AddProductImgColumnsToProducts < ActiveRecord::Migration[5.0]
 def up
    add_attachment :products, :product_img
  end

  def down
    remove_attachment :products, :product_img
  end
end
