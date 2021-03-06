FactoryBot.define do
  factory :dividend, class: 'Investments::Stock::Dividend' do
    stock
    value { Faker::Number.number(digits: 7) }
  end
end
