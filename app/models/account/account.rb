module Account
  class Account < ApplicationRecord
    belongs_to :user
    has_many :transactions, dependent: :destroy
    has_many :balances, dependent: :destroy
    has_many :sender_transference, class_name: 'Transference', foreign_key: 'sender_id', dependent: :destroy
    has_many :receiver_transference, class_name: 'Transference', foreign_key: 'receiver_id', dependent: :destroy
    has_many :treasuries, class_name: 'Investments::Treasury::Treasury', dependent: :destroy
    has_many :stocks, class_name: 'Investments::Stock::Stock', dependent: :destroy
    has_many :reports, class_name: 'Account::AccountReport', dependent: :destroy

    monetize :balance_cents

    enum kind: { savings: 0, broker: 1, card: 2 }

    scope :card_accounts, -> { where(kind: 'card') }
    scope :except_card_accounts, -> { where.not(kind: 'card') }
    scope :broker_accounts, -> { where(kind: 'broker') }
    # scope :savings_accounts, -> { where(kind: 'savings') }

    validates :name, presence: true, uniqueness: true
    validates :kind, presence: true

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
        total += stock.invested_value
      end
      total
    end

    def last_semester_balances
      create_balance if balances.empty?
      grouped_balances = {}
      semester_balances.find_each do |balance|
        grouped_balances[balance.date.strftime('%B %d, %Y').to_s] = balance.balance.to_f
      end
      grouped_balances
    end

    def last_semester_total_dividends_received
      grouped_dividends = {}
      stocks.each do |stock|
        dividends = stock.semester_total_dividends
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

    def incomes(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'income').sum(:value_cents))
    end

    def expenses(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'expense').sum(:value_cents))
    end

    def total_balance(date = DateTime.current)
      Money.new(incomes(date) - expenses(date))
    end

    def invested(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'investment').sum(:value_cents))
    end

    def total_stock_value
      total = 0
      total += stocks.inject(0) { |sum, stock| stock.current_total_value + sum }
      total
    end

    def find_report_by_date(date = DateTime.current)
      report = reports.find_by(date: date.beginning_of_month...date.end_of_month)

      report = create_report(date) if report.nil?
      report
    end

    private

    def create_report(date)
      reports.create!(date: date, incomes_cents: 0, expenses_cents: 0,
                      invested_cents: 0, final_cents: 0)
    end

    def semester_balances
      balances.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
    end
  end
end
