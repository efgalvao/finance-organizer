module Investments
  module Stock
    class DividendsController < ApplicationController
      before_action :set_stock, only: %i[new create]

      def index
        @stocks = policy_scope(Dividend)
      end

      def new
        @dividend = @stock.dividends.new
      end

      def create
        @dividend = Investments::Stock::CreateDividend.new(dividend_params).perform

        if @dividend
          redirect_to stock_path(@stock), notice: 'Dividend successfully created.'
        else
          render :new
        end
      end

      private

      def set_stock
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def dividend_params
        params.require(:investments_stock_dividend).permit(:date, :value).merge(stock_id: params[:stock_id])
      end
    end
  end
end
