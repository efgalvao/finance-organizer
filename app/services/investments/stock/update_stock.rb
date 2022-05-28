module Investments
  module Stock
    class UpdateStock < ApplicationService
      def initialize(params)
        @params = params
        @ticker = params.fetch(:ticker, '')
        @quantity = params.fetch(:quantity, 0)
        @invested = params.fetch(:invested, 0).to_f * 100
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def perform
        update_stock
      end

      private

      attr_reader :params, :stock, :ticker, :quantity, :invested

      def update_stock
        ActiveRecord::Base.transaction do
          stock.ticker = ticker.empty? ? stock.ticker : ticker
          stock.shares_total += quantity.to_i
          stock.invested_value_cents += invested
          stock.current_value_cents = new_current_value
          stock.current_total_value_cents = new_current_total_value
          stock.save
        end
      end

      def new_current_value
        if params[:value].nil?
          stock.current_value_cents
        else
          params[:value].to_f * 100
        end
      end

      def new_current_total_value
        if params[:value].nil?
          stock.current_value_cents * stock.shares_total
        else
          (params[:value].to_f * 100) * stock.shares_total
        end
      end
    end
  end
end
