class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  enum status: %i[Enabled Disabled]

  def ready_to_ship
    invoice_items.where(status: 'packaged').order(created_at: 'DESC')
  end

  def self.most_popular_items(limit = 5, order = 'DESC', merchant_id)
    select('items.name, items.id, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .joins(:invoice_items, invoices: :transactions)
      .where(transactions: { result: 0 }, merchant_id: merchant_id)
      .distinct
      .group(:id)
      .order("revenue #{order}")
      .limit(limit)
  end

  def self.top_merchants(order = 'DESC', limit = 5)
    hash = {}
    top5 = select('items.id, items.merchant_id, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
           .joins(:invoice_items, invoices: :transactions)
           .where(transactions: { result: 0 })
           .group(:id)
           .order("revenue #{order}")
           .limit(limit)

    top5.map do |item|
      merchant = Merchant.find(item.merchant_id)
      best_day = InvoiceItem.find_by(item_id: item.id).created_at.strftime('%B %d, %Y')
      hash[merchant.name] = "#{item.revenue.to_s(:delimited)}. Top selling date for #{merchant.name} was #{best_day}"
    end
    hash
  end
end
