FactoryBot.define do
  FactoryBot.define do
    factory :invoice_item do
      item
      invoice
      quantity { 2 }
      unit_price {Faker::Commerce.price.to_i}
      status {0}
    end
  end
end