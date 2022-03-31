FactoryBot.define do
  factory :transaction do
    account
    title { Faker::Commerce.product_name }
    value { Faker::Number.number(digits: 7) }
    date { DateTime.current }
  end
end
