# frozen_string_literals: true

module Account
  class UpdateAccountBalance < ApplicationService
    def initialize(params)
      @account = Account.find(params[:account_id])
      @amount = params.fetch(:amount, 0)
    end

    def self.call(params)
      new(params).call
    end

    def call
      update_account_balance
    end

    private

    attr_reader :account, :amount

    def update_account_balance
      account.balance_cents += amount.to_f * 100
      account.save
    end
  end
end
