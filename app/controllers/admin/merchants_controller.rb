class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    merchant.save

    flash[:notice] = 'Information has been successfully updated!'
    redirect_to "/admin/merchants/#{merchant.id}"
  end

  def update_status
    merchant = Merchant.find(params[:merchant_id])
    merchant.status = if merchant.status == 'Enable'
                        'Disable'
                      else
                        'Enable'
                      end

    merchant.save

    redirect_to '/admin/merchants'
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
