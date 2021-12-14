class User < ApplicationRecord
  has_many :balances, as: :balanceable, dependent: :destroy
  has_many :accounts, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def total_amount
    total = 0
    accounts.includes(:balances).each do |account|
      total += account.stock_plus_balance
    end
    total
  end

  def total_in_savings
    total = 0
    accounts.includes(:balances).each do |account|
      # print("#{account.name}, #{account.last_balance.balance}")
      total += account.last_balance.balance
    end
    total
  end

  def total_in_stocks
    total = 0
    accounts.includes(:balances).each do |account|
      total += account.total_stock_value
    end
    total
  end

  def create_balance
    
    value = total_amount
    
    balances.create(balance: value)
  end
  
  def monthly_balance
    if balances.last.date.month != DateTime.current.month || balances.empty?
      create_balance
    end
    grouped_balances = {}
    balances.each do |balance|
      grouped_balances[balance.date.strftime('%B %d, %Y').to_s] = balance.balance.to_f
    end
    grouped_balances
  end
end
