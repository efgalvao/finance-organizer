FactoryBot.define do
  factory :user_report do
    user
    date { Date.current }
    total { rand(1000) }
    savings { rand(1000) }
    stocks { rand(1000) }
  end
end
