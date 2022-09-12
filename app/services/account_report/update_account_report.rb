# frozen_string_literals: true

module AccountReport
  class UpdateAccountReport < ApplicationService
    def initialize(account_id:, params:)
      @account_id = account_id
      @params = params
      @date = set_date
    end

    def self.call(account_id:, params:)
      new(account_id: account_id, params: params).call
    end

    def call
      update_account_report
    end

    private

    attr_reader :account_id, :params, :date

    def update_account_report
      report.update(new_attributes)
    end

    def report
      @report ||= account.reports.where(date: date.beginning_of_month...date.end_of_month).first_or_initialize
    end

    def account
      @account ||= Account::Account.find(account_id)
    end

    def set_date
      return Time.zone.today if params.fetch(:date) == ''

      params.fetch(:date)
    end

    def new_attributes
      {
        date: date,
        incomes_cents: incomes,
        expenses_cents: expenses,
        invested_cents: invested,
        dividends_cents: dividends,
        final_cents: final_cents
      }
    end

    def incomes
      params.fetch(:income, 0) + report.incomes_cents
    end

    def expenses
      params.fetch(:expense, 0) + report.expenses_cents
    end

    def invested
      params.fetch(:investment, 0) + report.invested_cents
    end

    def dividends
      params.fetch(:dividends_cents, 0) + report.dividends_cents
    end

    def final_cents
      incomes - expenses - invested
    end
  end
end
