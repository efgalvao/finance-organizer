FactoryBot.define do
  factory :stock, class: 'Investments::Stock::Stock' do
    account
    ticker { Faker::Finance.stock_market }
    invested_value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }

    trait :with_shares do
      shares_total { Faker::Number.number(digits: 2) }
      current_value { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
      current_total_value { shares_total * current_value }
    end
  end
end
