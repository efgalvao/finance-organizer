FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    savings { true }
    balance { Faker::Number.number(digits: 7) }
    user
  end

  trait :stocks_account do
    savings { false }
  end
end
