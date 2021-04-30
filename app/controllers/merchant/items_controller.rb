class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merchant = Merchant.find(params[:id])
    item = Item.create(item_params)
    item.merchant_id = merchant.id
    item.status = 'Disabled'
    item.save

    flash[:notice] = 'Item created successfully!'
    redirect_to "/merchant/#{merchant.id}/items"
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

  def status_update
    merchant = Merchant.find(params[:id])
    item = Item.find(params[:item_id])

    item.status = if item.status == 'Enabled'
                    'Disabled'
                  else
                    'Enabled'
                  end


    item.save
    redirect_to "/merchant/#{merchant.id}/items"
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
