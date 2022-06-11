# frozen_string_literals: true

module Account
  class UpdateBalance < ApplicationService
    def initialize(params)
      @balance = Account.find(params[:account_id]).balances.current.first
      @amount = params.fetch(:amount, 0)
    end

    def self.call(params)
      new(params).call
    end

    def call
      update_balance
    end

    private

    attr_reader :balance, :amount

    def update_balance
      balance.balance_cents += amount.to_f * 100
      balance.save
    end
  end
end
