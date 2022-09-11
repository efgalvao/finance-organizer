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
      AccountReport::UpdateAccountReport.call(account_id: account_id, params: update_report_params)
      Transactions::CreateTransaction.call(params)
    end

    private

    attr_reader :params, :account_id, :value

    def update_report_params
      {
        date: params.fetch(:date),
        "#{params[:kind]}": value.to_f * 100
      }
    end
  end
end
