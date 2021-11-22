FactoryBot.define do
  factory :transaction do
    account
    title { Faker::Commerce.product_name }
    value { Faker::Number.number(9) }
  end
end
