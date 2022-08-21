FactoryBot.define do
  factory :user do
    name { Faker::Books::Dune.character }
    email { Faker::Internet.email }
    password { 12_345_678 }
    password_confirmation { 123_456_78 }
  end

  trait :with_account do
    after(:build) do |user|
      user.accounts << FactoryBot.build(:account)
    end
  end
end
