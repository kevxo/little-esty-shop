class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def ready_to_ship
    invoice_items.where(status: 'packaged').order(created_at: 'DESC')
  end
end
