FactoryBot.define do
  factory :account, class: 'Account::Account' do
    name { Faker::Company.name }
    savings { true }
    kind { 'savings' }
    balance { Faker::Number.number(digits: 7) }
    user
  end

  trait :broker_account do
    kind { 'broker' }
  end

  trait :card_account do
    kind { 'card' }
  end
end
