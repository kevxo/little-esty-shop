class AdminController < ApplicationController
  def index
    @top_5_customers = Invoice.top_5_customers
    @items = Item.all
  end
end