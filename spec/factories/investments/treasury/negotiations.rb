FactoryBot.define do
  factory :negotiation, class: 'Investments::Treasury::Negotiation' do
    date { '2022-09-19' }
    invested_cents { 0 }
    shares { rand(100) }
    kind { :buy }
  end
end
