module Investments
  module Stock
    class PricesController < ApplicationController
      before_action :set_stock, only: %i[new create]
      def new
        @price = @stock.prices.new
      end

      def create
        @price = Investments::Stock::CreatePrice.call(price_params)

        if @price
          redirect_to stock_path(@stock), notice: 'Price successfully created.'
        else
          render :new
        end
      end

      private

      def set_stock
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def price_params
        params.require(:price).permit(:date, :value).merge(stock_id: params[:stock_id])
      end
    end
  end
end
