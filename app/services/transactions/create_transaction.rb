module Transactions
  class CreateTransaction < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      if params[:kind] == 'income'
        Transactions::CreateIncome.call(params)
      else
        Transactions::CreateExpense.call(params)
      end
    end

    private

    attr_reader :params
  end
end
