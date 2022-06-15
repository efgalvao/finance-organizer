module Transactions
  class ProcessTransaction < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      case params[:kind]
      when 'income'
        Transactions::CreateIncome.call(params)
      when 'expense'
        Transactions::CreateExpense.call(params)
      else
        'Invalid kind'
      end
    end

    private

    attr_reader :params
  end
end
