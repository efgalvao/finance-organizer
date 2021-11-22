FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    savings { true }
    balance { 10_000 }
    user
  end
end
