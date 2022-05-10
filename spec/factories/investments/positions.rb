FactoryBot.define do
  factory :position, class: 'Investments::Position' do
    treasury
    date { DateTime.current }
    amount { rand(10_000) }
  end
end
