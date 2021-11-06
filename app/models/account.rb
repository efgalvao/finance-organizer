class Account < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user
  has_many :stocks, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :balances, as: :balanceable, dependent: :destroy

  monetize :balance_cents

  scope :savings_accounts, -> { where(savings: true) }

  scope :stocks_accounts, -> { where(savings: false) }

  # VALIDATIONS
  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :balance, presence: true

  def generate_balance
    total = balance + stocks.inject(0) { |sum, stock| stock.updated_balance + sum }
    if balances.current.blank?
      balance = balances.create(balance: total)
    else
      balance = balances.current.first
      balance.balance = total
    end
    balance.save
    balance
  end

  def total_invested
    total = 0
    stocks.each do |stock|
      total += stock.total_invested
    end
    total
  end

  def monthly_balance
    generate_balance if balances.empty?
    balances.group_by_month(:date, last: 12, current: true).average('balance')
  end

  def generate_past_balance(month, year)
    date = DateTime.new(year, month, -1)
    total = stocks.inject(0) { |sum, stock| stock.past_stock_balance(date) + sum }
    if balances.past_date(date).first.blank?
      balance = balances.create(balance: total, date: date)
    else
      balance = balances.past_date(date).first
      balance.balance = total
    end
    balance.save
    balance
  end

  def owner?(asker)
    user == asker
  end

  def updated_balance
    updated_balance = balance_cents + transactions.income.sum(:value_cents) - transactions.expense.sum(:value_cents)
    Money.new(updated_balance)
  end

  def current_month_transactions
    transactions.where(date: DateTime.current.beginning_of_month...DateTime.current.end_of_month)
  end
end
