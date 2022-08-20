# frozen_string_literals: true

module AccountReport
  class GetCurrentAccountReport < ApplicationService
    def initialize(account_id:)
      # @report = report
      @account_id = account_id
      # @incomes = params.fetch(:incomes, 0)
      # @expenses = params.fetch(:expenses, nil)
      # @invested = params.fetch(:invested, 0)
      # @dividends = params.fetch(:dividends, nil)
      # @total_balance = params.fetch(:total_alance, nil)
      @date = set_date
    end

    def self.call(account_id:)
      new(account_id: account_id).call
    end

    def call
      # report = reports.find_by(date: date.beginning_of_month...date.end_of_month)
      current_account_report
    end

    private

    attr_reader :account_id, :date

    def current_account_report
      account.reports.where(date: date.beginning_of_month...date.end_of_month).first_or_create

      # report.date = DateTime.current
      # report.incomes_cents = incomes
      # report.expenses_cents = expenses
      # report.invested_cents = invested
      # report.final_cents = total_balance
      # report.dividends += dividends
      # report.save
    end

    # def report
    #   @report ||= @account.reports.where(date: date.beginning_of_month...date.end_of_month).first_or_initialize
    # end

    def account
      Account::Account.find(account_id)
    end

    def set_date
      return Time.zone.today if params.fetch(:date) == ''

      params.fetch(:date)
    end
  end
end
