class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: %i[packaged shipped pending]
end
