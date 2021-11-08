FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    savings { true }
    balance { Faker::Number.decimal(2) }
  end
end
