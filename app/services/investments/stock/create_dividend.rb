module Investments
  module Stock
    class CreateDividend < ApplicationService
      def initialize(params)
        @params = params
        @value = params.fetch(:value, 0)
        @date = set_date
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def self.call(params)
        new(params).call
      end

      def call
        ActiveRecord::Base.transaction do
          Investments::Stock::Dividend.create!(dividend_params)

          Transactions::ProcessTransaction.call(transactions_params)
        end
      end

      private

      attr_reader :value, :date, :stock, :params

      def dividend_params
        { value: value, date: date, stock_id: stock.id }
      end

      def transactions_params
        {
          account_id: stock.account.id,
          value: (value.to_f * stock.shares_total),
          title: "#{stock.ticker} dividends",
          date: date,
          kind: 'income'
        }
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        params.fetch(:date)
      end
    end
  end
end
