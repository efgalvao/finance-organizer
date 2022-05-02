FactoryBot.define do
  factory :treasury do
    account
    name { Faker::Company.name }
  end
end
