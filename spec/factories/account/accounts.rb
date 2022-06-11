FactoryBot.define do
  factory :account, class: 'Account::Account' do
    name { Faker::Company.name }
    savings { true }
    kind { 0 }
    balance { Faker::Number.number(digits: 7) }
    user
  end

  trait :broker_account do
    kind { 1 }
  end

  trait :card_account do
    kind { 2 }
  end

  trait :stocks_account do
    savings { false }
  end
  trait :with_balance do
    after(:build) do |account|
      account.balances << FactoryBot.build(:balance)
    end
  end
end
