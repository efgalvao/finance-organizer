# frozen_string_literals: true

module AccountReport
  class CreateAccountReport < ApplicationService
    def initialize(account_id:, date:)
      @account_id = account_id
      @date = date
    end

    def self.call(account_id:, date: DateTime.current)
      new(account_id: account_id, date: date).call
    end

    def call
      create_account_report
    end

    private

    attr_reader :account_id, :date

    def create_account_report
      account.reports.create!(account_report_params)
    end

    def account
      @account ||= Account::Account.find(account_id)
    end

    def account_report_params
      {
        date: date,
        incomes_cents: incomes.cents,
        expenses_cents: expenses.cents,
        invested_cents: invested.cents,
        final_cents: total_balance.cents
      }
    end

    def incomes(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'income').sum(:value_cents))
    end

    def expenses(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'expense').sum(:value_cents))
    end

    def card_expenses(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'expense').sum(:value_cents))
    end

    def invested(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'investment').sum(:value_cents))
    end

    def total_balance
      Money.new(incomes(date) - expenses(date) - invested(date))
    end

    def transactions
      @transactions ||= account.transactions.where(date: date.beginning_of_month...date.end_of_month)
    end
  end
end
