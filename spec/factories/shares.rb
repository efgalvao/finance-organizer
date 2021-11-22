FactoryBot.define do
  factory :share do
    aquisition_value { rand(1000) }
    stock
  end
end
