class Merchant::DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    @top_successful_transactions = Invoice.most_successful_transactions(@merchant.id)
  end
end