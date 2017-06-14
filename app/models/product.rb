class Product < ApplicationRecord
	has_many :product_categories , dependent: :destroy
	has_many :categories, through: :product_categories

	has_many :product_orders , dependent: :destroy
	has_many :orders, through: :product_orders

	has_attached_file :product_img, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :product_img, content_type: /\Aimage\/.*\z/

	def self.by_year year
	   joins(:orders).where('orders.active = ? AND extract(year from orders.updated_at) = ?',false, year)
	end

	def self.by_month month
	   joins(:orders).where('orders.active = ? AND extract(month from orders.updated_at) = ?',false, month)
	end

	def self.by_day day
	   joins(:orders).where('orders.active = ? AND extract(day from orders.updated_at) = ?',false, day)
	end
	
  def self.range start_date, end_date
    joins(:orders).where('orders.active = ? AND orders.updated_at = ?',false, params[:start_date]..params[:end_date])
  end

end
