FactoryBot.define do
  factory :price, class: 'Investments::Stock::Price' do
    value { rand(10_000) }
    stock
  end
end
