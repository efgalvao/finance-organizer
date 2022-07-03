module Transactions
  class ProcessTransaction < ApplicationService
    def initialize(params)
      @params = params
      @account_id = params.fetch(:account_id)
      @value = params.fetch(:value, 0)
    end

    def self.call(params)
      new(params).call
    end

    def call
      if params.fetch(:kind) == 'income'
        Account::UpdateAccountBalance.call(account_id: account_id, amount: value.to_f)
      elsif params.fetch(:kind) == 'expense'
        Account::UpdateAccountBalance.call(account_id: account_id, amount: -value.to_f)
      elsif params.fetch(:kind) == 'investment'
        Account::UpdateAccountBalance.call(account_id: account_id, amount: -value.to_f)
      elsif params.fetch(:kind) == 'transfer' && params[:receiver] == true
        Account::UpdateAccountBalance.call(account_id: account_id, amount: value.to_f)
      elsif params.fetch(:kind) == 'transfer' && params[:receiver] == false
        Account::UpdateAccountBalance.call(account_id: account_id, amount: -value.to_f)
      else
        'Invalid kind'
      end
      Transactions::CreateTransaction.call(params)
    end

    private

    attr_reader :params, :account_id, :value
  end
end
