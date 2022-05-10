FactoryBot.define do
  factory :position, class: 'Investments::Treasury::Position' do
    treasury
    date { DateTime.current }
    amount { rand(10_000) }
  end
end
