FactoryBot.define do
  factory :balance do
    balance { Faker::Number.number(digits: 7) }
    for_account

    trait :for_account do
      association :account, factory: :account
    end
  end
end
