FactoryBot.define do
  factory :transaction, class: 'Account::Transaction' do
    account
    title { Faker::Commerce.product_name }
    value { Faker::Number.number(digits: 7) }
    date { '2022-04-18' }
    kind { 'income' }
  end

  trait :expense do
    kind { 'expense' }
  end

  trait :transfer do
    kind { 'transfer' }
  end

  trait :investment do
    kind { 'investment' }
  end
end
