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

  def create_balance
    value = balances.newest_balance.first&.balance || 0

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
    generate_balance if balances.empty?
    balancos = {}
    balances.each do |balance|
      balancos[balance.date.strftime('%B %d, %Y').to_s] = balance.balance.to_f
    end
    # balances.group_by_month(:date, last: 12, current: true).maximum(humanized_money @money_object	)
    balancos
  end

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

  def owner?(asker)
    user == asker
  end

  def last_balance
    if balances.newest_balance.first.nil?
      return create_balance
    else
      balances.newest_balance.first
    end

  end

  def current_month_transactions
    transactions.where(date: DateTime.current.beginning_of_month...DateTime.current.end_of_month)
  end
end
