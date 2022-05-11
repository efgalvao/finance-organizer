FactoryBot.define do
  factory :negotiation, class: 'Investments::Treasury::Negotiation' do
    treasury
    date { DateTime.current }
    amount { rand(10_000) }
    shares { rand(100) }
    kind { :buy }
  end
end
