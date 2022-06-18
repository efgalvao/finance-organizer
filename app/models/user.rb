class User < ApplicationRecord
  # has_many :user_reports, dependent: :destroy
  has_many :reports, class_name: 'UserReport', dependent: :destroy
  has_many :accounts, class_name: 'Account::Account', dependent: :destroy
  has_many :transferences, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  # def total_amount
  #   total = 0
  #   accounts.find_each do |account|
  #     total += account.stock_plus_balance
  #   end
  #   total
  # end

  # def total_balance
  #   total = 0
  #   accounts.find_each do |account|
  #     total += account.balance
  #   end
  #   total
  # end

  # def total_in_stocks
  #   total = 0
  #   accounts.broker_accounts.each do |account|
  #     total += account.total_stock_value
  #   end
  #   total
  # end

  # def semester_summary
  #   create_report if user_reports.empty? || user_reports.last.date.month != DateTime.current.month
  #   update_current_user_report
  #   Statements::CreateUserSummary.new(semester_reports).perform
  # end

  # def last_semester_total_dividends
  #   grouped_dividends = {}
  #   accounts.each do |account|
  #     dividends = account.last_semester_total_dividends_received
  #     grouped_dividends = grouped_dividends.merge(dividends) { |_k, a_value, b_value| a_value + b_value }
  #   end
  #   grouped_dividends
  # end

  # def incomes_expenses_report
  #   Statements::CreateIncomesExpenses.new(self).perform
  # end

  # def current_user_report

  # end

  # def update_current_user_report
  #   user_report = current_month_report

  #   user_report.date = DateTime.current
  #   user_report.total = total_amount
  #   user_report.savings = total_balance
  #   user_report.stocks = total_in_stocks
  #   user_report.save
  # end

  # def semester_reports
  #   user_reports.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
  # end

  # def create_report
  #   user_reports.create(total: total_amount, savings: total_balance, stocks: total_in_stocks)
  # end
end
