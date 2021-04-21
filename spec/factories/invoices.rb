FactoryBot.define do
  FactoryBot.define do
    factory :invoice do
      customer
      status {'completed'}
    end
  end
end