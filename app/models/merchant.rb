class Merchant < ApplicationRecord
  has_many :items

  enum status: %i[Enable Disable]
end
