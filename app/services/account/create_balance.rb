# frozen_string_literals: true

module Account
  class CreateBalance < ApplicationService
    def initialize(params)
      @params = params
      @balance = params.fetch(:balance, 0)
      @date = set_date
      @account_id = params.fetch(:account_id, true)
    end

    def self.call(params)
      new(params).call
    end

    def call
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
      return Time.zone.today unless params.fetch(:date, '').present?

      params.fetch(:date)
    end
  end
end
