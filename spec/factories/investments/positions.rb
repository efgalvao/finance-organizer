FactoryBot.define do
  factory :position do
    treasury
    date { DateTime.current }
    amount { rand(10_000) }
  end
end
