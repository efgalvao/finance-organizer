FactoryBot.define do
  factory :dividend, class: 'Investments::Dividends' do
    stock
    value { Faker::Number.number(digits: 7) }
  end
end
