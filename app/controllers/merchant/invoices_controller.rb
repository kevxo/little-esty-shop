class Merchant::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    invoice_ids = InvoiceItem.where(item_id: @merchant.items.pluck(:id)).pluck(:invoice_id)
    @invoices = Invoice.where(id: invoice_ids)
  end

  def show
    @merchant = Merchant.find(params[:id])
    @invoice = Invoice.find(params[:invoice_id])
    @customer = Customer.find(@invoice.customer_id)
  end

  def update
    merchant = Merchant.find(params[:id])
    invoice_item = InvoiceItem.find(params[:invoice_item_id])
    invoice = Invoice.find(params[:invoice_id])
    invoice_item.status = params[:status]
    invoice_item.save

    redirect_to "/merchant/#{merchant.id}/invoices/#{invoice.id}"
  end
end