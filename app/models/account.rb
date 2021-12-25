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

  def create_balance
    value = balances.newest_balance.first&.balance || balance

    balances.create(balance: value)
  end

  def update_balance(value)
    current_month_balance = balances.current.any? ? balances.current.first : create_balance

    current_month_balance.balance += value
    current_month_balance.date = DateTime.current
    current_month_balance.save
  end

  def total_invested
    total = 0
    stocks.each do |stock|
      total += stock.total_invested
    end
    total
  end

  def monthly_balance
    create_balance if balances.empty?
    grouped_balances = {}
    balances.each do |balance|
      grouped_balances[balance.date.strftime('%B %d, %Y').to_s] = balance.balance.to_f
    end
    grouped_balances
  end

  def monthly_dividends_received
    grouped_dividends = {}
    stocks.each do |stock|
      dividends = stock.monthly_dividends_total
      grouped_dividends = grouped_dividends.merge(dividends) { |_k, a_value, b_value| a_value + b_value }
    end
    grouped_dividends
  end

  def owner?(asker)
    user == asker
  end

  def last_balance
    return create_balance if balances.current.blank?

    current_month_balance = balances.current.first
    current_month_balance.date = DateTime.current
    current_month_balance.save
    current_month_balance
  end

  def current_month_transactions
    transactions.where(date: DateTime.current.beginning_of_month...DateTime.current.end_of_month)
  end

  # Refactor this method with methods incomes and expenses
  def generate_past_balance(month, year)
    date = DateTime.new(year, month, -1)
    incomes = transactions.where(date: date.beginning_of_month...date.end_of_month, kind: 'income').sum(:value_cents)
    expenses = transactions.where(date: date.beginning_of_month...date.end_of_month, kind: 'expense').sum(:value_cents)
    total = (incomes - expenses) / 100.0
    total += stocks.inject(0) { |sum, stock| stock.past_stock_balance(date) + sum }
    if balances.past_date(date).first.blank?
      balance = balances.create(balance: total, date: date)
    else
      balance = balances.past_date(date).first
      balance.balance = total
    end
    balance.save
    balance
  end

  def incomes(date)
    Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month, kind: 'income').sum(:value_cents))
  end

  def expenses(date)
    Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month, kind: 'expense').sum(:value_cents))
  end

  def total_balance(date)
    Money.new(incomes(date) - expenses(date))
  end

  def total_stock_value
    total = 0
    total += stocks.inject(0) { |sum, stock| stock.updated_balance + sum }
    total
  end

  def stock_plus_balance
    total_stock_value + last_balance.balance
  end  
end
