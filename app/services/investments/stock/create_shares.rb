module Investments
  module Stock
    class CreateShares < ApplicationService
      def initialize(params)
        @params = params
        @stock = Investments::Stock::Stock.find(params[:stock_id])
        @quantity = params.fetch(:quantity, 1).to_i
        @date = set_date
        @invested = params.fetch(:invested, 0).to_f
      end

      def self.call(params)
        new(params).call
      end

      def call
        create_share
      end

      private

      attr_reader :params, :stock, :quantity, :date, :invested

      def create_share
        ActiveRecord::Base.transaction do
          Transactions::ProcessTransaction.call(transactions_params)
          Investments::Stock::UpdateStock.call(update_stock_params)
          Investments::Stock::Share.create!(share_params)
        end
      end

      def share_params
        { date: date, quantity: quantity, invested: invested, stock_id: stock.id }
      end

      def transactions_params
        {
          account_id: stock.account.id,
          value: invested,
          title: "Invested in #{stock.ticker} shares",
          date: date,
          kind: 'investment'
        }
      end

      def update_stock_params
        { date: date, quantity: quantity, invested: invested, stock_id: stock.id,
          value: (invested / quantity) }
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        DateTime.parse(params.fetch(:date))
      end
    end
  end
end
