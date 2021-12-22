FactoryBot.define do
  factory :dividend do
    stock
    value { Faker::Number.number(digits: 7) }
  end
end
