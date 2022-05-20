module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @params = params
        @ticker = params.fetch(:ticker, 'Invalid ticker')
        @quantity = params.fetch(:quantity, 1)
        @invested = params.fetch(:invested, 0).to_f * 100
        @value = params.fetch(:value, nil)
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def perform
        update_stock(params)
      end

      private

      def update_stock(params)
        ActiveRecord::Base.transaction do
          stock.ticker = params.fetch(:ticker) { stock.ticker }
          stock.shares_total += params.fetch(:quantity, 0).to_i
          stock.invested_value_cents += (params.fetch(:invested, 0).to_f * 100)
          stock.current_value_cents = new_current_value

          stock.save
        end
      end

      def new_current_value
        if params[:value].nil?
          stock.current_value_cents
        else
          (params[:value].to_f * 100) * stock.shares_total
        end
      end

      attr_reader :params, :stock
    end
  end
end
