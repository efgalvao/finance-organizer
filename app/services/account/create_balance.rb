# frozen_string_literals: true

module Account
  class CreateBalance < ApplicationService
    def initialize(params)
      @params = params
      @balance = params.fetch(:balance, 0)
      @date = set_date
      @account_id = params.fetch(:account_id, true)
    end

    def perform
      create_balance
    end

    private

    attr_reader :balance, :date, :account_id, :params

    def create_balance
      ActiveRecord::Base.transaction do
        Balance.create(date: date, balance: balance, account_id: account_id)
      end
    end

    def set_date
      if params[:date] == ''
        Time.zone.today
      else
        params.fetch(:date)
      end
    end
  end
end
