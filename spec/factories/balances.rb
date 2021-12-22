FactoryBot.define do
  factory :balance do
    balance { Faker::Number.number(digits: 7) }
    for_account

    trait :for_user do
      association :balanceable, factory: :user
    end

    trait :for_account do
      association :balanceable, factory: :account
    end
  end
end
