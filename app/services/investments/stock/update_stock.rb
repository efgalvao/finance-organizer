module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @params = params
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def perform
        update_stock(params)
      end

      private

      def update_stock(params)
        ActiveRecord::Base.transaction do
          stock.ticker = params.fetch(:ticker) { stock.ticker }
          stock.shares_total += params.fetch(:shares, 0).to_i
          stock.invested_value_cents += (params.fetch(:invested, 0).to_f * 100)
          stock.current_value_cents = new_current_value
          stock.save
        end
      end

      def new_current_value
        if params[:value]
          (params[:value].to_f * 100) * stock.shares_total
        else
          (params[:invested].to_f * 100) * stock.shares_total
        end
      end

      attr_reader :params, :stock
    end
  end
end
