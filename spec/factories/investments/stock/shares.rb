FactoryBot.define do
  factory :share, class: 'Investments::Stock::Share' do
    invested { rand(1000) }
    stock
  end
end
