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

      # def current_price
      #   new_price = Investments::Stock::PriceUpdater.get_price(@stock.ticker)
      #   price = Investments::Stock::CreatePrice.call(stock_id: @stock.id, value: new_price)

      #   if price
      #     redirect_to stock_path(@stock), notice: 'Price successfully updated.'
      #   else
      #     redirect_to stock_path(@stock), notice: 'Price not updated.'
      #   end
      # end

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
