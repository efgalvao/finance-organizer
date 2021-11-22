FactoryBot.define do
  factory :dividend do
    stock
    value { Faker::Number.number(9) }
  end
end
