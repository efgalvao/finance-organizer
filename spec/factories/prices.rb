FactoryBot.define do
  factory :price do
    price { rand(10_000) }
    stock
  end
end
