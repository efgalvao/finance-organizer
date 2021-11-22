FactoryBot.define do
  factory :balance do
    balance { Faker::Number.number(9) }
  end
end
