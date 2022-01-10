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

  def update_current_user_report
    user_report = user_reports.current_month
    user_report.date = DateTime.current
    user_report.total = total_amount
    user_report.savings = total_in_savings
    user_report.stocks = total_in_stocks
    user_report.save
  end

  def monthly_report_total
    create_report if user_reports.empty? || user_reports.last.date.month != DateTime.current.month
    update_current_user_report
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.total.to_f
    end
    grouped_reports
  end

  def monthly_report_savings
    create_report if user_reports.last.date.month != DateTime.current.month || user_reports.empty?
    update_current_user_report
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.savings.to_f
    end
    grouped_reports
  end

  def monthly_report_stocks
    create_report if user_reports.empty? || user_reports.last.date.month != DateTime.current.month
    update_current_user_report
    grouped_reports = {}
    user_reports.each do |report|
      grouped_reports[report.date.strftime('%B %d, %Y').to_s] = report.stocks.to_f
    end
    grouped_reports
  end

  def total_dividends_past_months
    grouped_dividends = {}
    accounts.each do |account|
      dividends = account.monthly_dividends_received
      grouped_dividends = grouped_dividends.merge(dividends) { |_k, a_value, b_value| a_value + b_value }
    end
    grouped_dividends
  end
end
