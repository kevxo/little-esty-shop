FactoryBot.define do
  FactoryBot.define do
    factory :item do
      name {Faker::Commerce.product_name}
      description { 'Amazing and Great to have'}
      unit_price {Faker::Commerce.price.to_i}
      merchant
    end
  end
end