class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @merchant = Merchant.find(params[:id])
    @item = Item.find(params[:item_id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
    @item = Item.find(params[:item_id])
  end

  def update
    item = Item.find(params[:item_id])
    merchant = Merchant.find(params[:id])
    item.update(item_params)

    flash[:notice] = 'Item has been updated successfully!'
    redirect_to "/merchant/#{merchant.id}/items/#{item.id}"
  end

  private

    def item_params
      params.permit(:name, :description, :unit_price)
    end
end