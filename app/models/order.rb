class Order < ApplicationRecord
	has_many :product_orders , dependent: :destroy
	has_many :products, through: :product_orders
	belongs_to :user
	# scope :active, -> { where(active: true).last }
	def self.active
      where(active: true).last
	end

	def self.by_year year
	   where('active = ? AND extract(year from updated_at) = ?',false, year)
	end

	def self.by_month month
	   where('active = ? AND extract(month from updated_at) = ?',false, month)
	end

	def self.by_day day
	   where('active = ? AND extract(day from updated_at) = ?',false, day)
	end
	
  def self.range start_date, end_date
    where('active = ? AND updated_at = ?',false, params[:start_date]..params[:end_date])
  end
end
