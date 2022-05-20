module Investments
  module Stock
    class CreateStock < ApplicationService
      def initialize(stock_params)
        @ticker = stock_params.fetch(:ticker)
        @account_id = stock_params.fetch(:account_id)
      end

      def perform
        create_stock
      end

      private

      attr_reader :ticker, :account_id

      def create_stock
        Investments::Stock::Stock.create(ticker: ticker, account_id: account_id)
      end
    end
  end
end
