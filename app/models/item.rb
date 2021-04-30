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
end
