class AddFieldToOrders < ActiveRecord::Migration[5.0]
  def change
  	 add_column :orders, :active, :boolean, default: true
  end
end
