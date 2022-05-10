FactoryBot.define do
  factory :treasury, class: 'Investments::Treasury' do
    account
    name { Faker::Company.name }
  end
end
