require 'faker'

puts 'Seeding database...'

users = User.create([{ name: 'Dev 1', email: 'dev1@example.com', password: 'password' },
                     { name: 'Dev 2', email: 'dev2@example.com', password: 'password' }])
users.each do |user|
  Account.create([{ name: "Savings-#{user.id}", user_id: user.id, savings: true, balance: 0 },
                  { name: "Stocks-#{user.id}", user_id: user.id, savings: false, balance: 0 }])
  Category.create([{ name: 'Dividends', user_id: user.id }, { name: 'Salary', user_id: user.id },
                   { name: 'Fee', user_id: user.id }, { name: 'House', user_id: user.id },
                   { name: 'Food', user_id: user.id }, { name: 'Taxes', user_id: user.id },
                   { name: 'Transport', user_id: user.id }, { name: 'Entertainment', user_id: user.id },
                   { name: 'Other', user_id: user.id }, { name: 'Credit Card', user_id: user.id }])
end

accounts = Account.all
stocks_accounts = Account.where(savings: false)

accounts.each do |account|
  6.times do
    Transaction.create(
      account_id: account.id, value: rand(1..1000), date: rand(6.months).seconds.ago,
      category_id: rand(1..10), kind: rand(0..1), title: Faker::Commerce.product_name
    )
  end

  (0..3).each do |n|
    account.balances.create(balance: rand(1000..10_000), date: DateTime.current - n.month)
  end
end

stocks_accounts.each do |account|
  2.times do
    stock = Stock.create(account_id: account.id, name: Faker::Finance.ticker)
    (0..3).each do |n|
      stock.dividends.create(value: rand, date: DateTime.current - n.months)
      stock.shares.create(date: DateTime.current - n.months,
                          value: rand(1..100))
      stock.prices.create(date: DateTime.current - n.months,
                          price: rand(1..100))
    end
  end
end

puts 'Finished!'
