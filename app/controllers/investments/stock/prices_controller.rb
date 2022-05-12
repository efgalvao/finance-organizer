module Investments
  module Stock
    class PricesController < ApplicationController
      def new
        @price = Price.new
      end

      def create
        @price = Price.new(price_params)

        if @price.save
          redirect_to prices_path, notice: 'Price successfully created.'
        else
          render :new

        end
      end

      private

      def price_params
        params.require(:price).permit(:date, :price, :stock_id)
      end
    end
  end
end
