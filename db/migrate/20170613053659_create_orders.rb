class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
