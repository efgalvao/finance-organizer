FactoryBot.define do
  factory :stock do
    account
    name { Faker::Finance.stock_market }
  end
end
