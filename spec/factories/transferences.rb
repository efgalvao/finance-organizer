FactoryBot.define do
  factory :transference do
    sender { create(:account) }
    receiver { create(:account) }
    date { Date.current }
    amount { rand(1000) }
  end
end
