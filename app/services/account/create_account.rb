# frozen_string_literals: true

module Account
  class CreateAccount < ApplicationService
    def initialize(params)
      @balance = params.fetch(:balance, 0)
      @name = params.fetch(:name, nil)
      @savings = params.fetch(:savings, true)
      @user_id = params.fetch(:user_id, nil)
    end

    def self.call(params)
      new(params).call
    end

    def call
      create_account
    end

    private

    attr_reader :balance, :name, :savings, :user_id

    def create_account
      ActiveRecord::Base.transaction do
        account = Account.create!(name: name, balance: balance, savings: savings, user_id: user_id)
        CreateBalance.call({ balance: balance, account_id: account.id })
        account
      end
    rescue ActiveRecord::RecordInvalid
      e
    end
  end
end
