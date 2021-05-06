class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.most_successful_transactions(limit = 5, order = 'DESC', merchant_id)
    top_successful_transactions = select('invoices.customer_id, count(transactions.result = 0) as customers_successful_transactions')
                                  .joins(:invoice_items, :transactions, :items)
                                  .where(transactions: { result: 'success' }, items: { merchant_id: merchant_id })
                                  .group(:customer_id)
                                  .order("customers_successful_transactions #{order}")
                                  .limit(limit)

    top_successful_transactions.map do |invoice|
      customer = Customer.find(invoice.customer_id)
      "#{customer.first_name} #{customer.last_name} - #{invoice.customers_successful_transactions}"
    end
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end
end
