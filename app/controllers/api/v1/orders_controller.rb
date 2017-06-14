class Api::V1::OrdersController < ApplicationController
  respond_to :json

  def get_products
  	begin
      @products = Product.by_year params[:year]  if params[:year].present?
      @products =  (params[:year].present? ? @products : Product ).by_month params[:month] if params[:month].present?
      @products = ((params[:year].present? || params[:month].present?) ? @products : Product ).by_day params[:day]   if params[:day].present?
      @products = Product.range(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
  	 respond_with @products
  	rescue
  	   respond_with errors: "Wrong attributes"
  	end
  end

  def get_orders
    begin
      @orders = Order.by_year params[:year]  if params[:year].present?
      @orders =  (params[:year].present? ? @orders : Product ).by_month params[:month] if params[:month].present?
      @orders = ((params[:year].present? || params[:month].present?) ? @orders : Product ).by_day params[:day]   if params[:day].present?
      @orders = Order.range(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
     respond_with @orders
    rescue
       respond_with errors: "Wrong attributes"
    end
  end
end