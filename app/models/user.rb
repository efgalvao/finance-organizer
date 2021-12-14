class User < ApplicationRecord
  has_many :user_reports, dependent: :destroy
  has_many :accounts, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def total_amount
    total = 0
    accounts.includes(:balances).find_each do |account|
      total += account.stock_plus_balance
    end
    total
  end

  def total_in_savings
    total = 0
    accounts.includes(:balances).find_each do |account|
      # print("#{account.name}, #{account.last_balance.balance}")
      total += account.last_balance.balance
    end
    total
  end

  def total_in_stocks
    total = 0
    accounts.includes(:balances).find_each do |account|
      total += account.total_stock_value
    end
    total
  end

  def create_report
    user_reports.create(total: total_amount, savings: total_in_savings, stocks: total_in_stocks)
  end

  def monthly_report_total
    create_report if user_reports.empty? || user_reports.last.date.month != DateTime.current.month
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.total.to_f
    end
    grouped_reports
  end

  def monthly_report_savings
    create_report if user_reports.last.date.month != DateTime.current.month || user_reports.empty?
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.savings.to_f
    end
    grouped_reports
  end

  def monthly_report_stocks
    create_report if user_reports.empty? || user_reports.last.date.month != DateTime.current.month
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.stocks.to_f
    end
    grouped_reports
  end
end
