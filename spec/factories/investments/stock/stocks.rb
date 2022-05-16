FactoryBot.define do
  factory :stock, class: 'Investments::Stock::Stock' do
    account
    ticker { Faker::Finance.stock_market }

    trait :with_shares do
      shares_total { Faker::Number.number(digits: 2) }
    end
  end
end
