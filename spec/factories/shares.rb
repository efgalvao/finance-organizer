FactoryBot.define do
  factory :share do
    stock
    aquisition_date
    aquisition_value { rand(1000) }
    balance { Faker::Number.decimal(2) }
  end
end
