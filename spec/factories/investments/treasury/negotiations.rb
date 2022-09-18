FactoryBot.define do
  factory :negotiation, class: 'Investments::Treasury::Negotiation' do
    treasury
    date { '2022-09-19' }
    invested { rand(10_000) }
    shares { rand(100) }
    kind { :buy }
  end
end
