module Investments
  module Stock
    class DividendsController < ApplicationController
      def index
        @stocks = policy_scope(Dividend)
      end

      def new
        @dividend = Dividend.new
      end

      def create
        @dividend = Dividend.create(dividend_params)

        if @dividend.valid?
          redirect_to dividends_path, notice: 'Dividend successfully created.'
        else
          render :new
        end
      end

      private

      def dividend_params
        params.require(:dividend).permit(:date, :value, :stock_id)
      end
    end
  end
end
