class Merchant::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
    invoice_ids = InvoiceItem.where(item_id: @merchant.items.pluck(:id)).pluck(:invoice_id)
    @invoices = Invoice.where(id: invoice_ids)
  end

  def show
    @invoice = Invoice.find(params[:invoice_id])
    @customer = Customer.find(@invoice.customer_id)
  end
end