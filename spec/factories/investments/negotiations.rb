FactoryBot.define do
  factory :negotiation do
    treasury
    date { DateTime.current }
    value { rand(10_000) }
    shares { rand(100) }
    kind { :buy }
  end
end
