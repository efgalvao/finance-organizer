module Investments
  module Stock
    class StocksController < ApplicationController
      before_action :set_stock, only: %i[show edit update destroy current_price]

      def index
        @stocks = policy_scope(Stock).all.includes(:prices).order(name: :asc)
      end

      def show
        authorize @stock
      end

      def new
        @account = Account::Account.find(params[:account_id])
        @stock = Investments::Stock::Stock.new
      end

      def edit
        authorize @stock
      end

      def create
        @stock = Investments::Stock::CreateStock.call(stock_params)

        if @stock.valid?
          redirect_to stock_path(@stock), notice: 'Stock successfully created.'
        else
          render :new
        end
      end

      def update
        authorize @stock

        if @stock.update(ticker: stock_params[:ticker])
          redirect_to stock_path(@stock), notice: 'Stock successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        authorize @stock

        @stock.destroy
        redirect_to stocks_url, notice: 'Stock successfully removed.'
      end

      def current_price
        response = Investments::Stock::PriceUpdater.get_price(@stock.ticker)
        price = Investments::Stock::CreatePrice.call(response.merge(stock_id: @stock.id))

        if price
          redirect_to stock_path(@stock), notice: 'Price successfully updated.'
        else
          redirect_to stock_path(@stock), notice: 'Price not updated.'
        end
      end

      private

      def set_stock
        @stock = Stock.find(params[:id])
      end

      def stock_params
        params.require(:stock).permit(:ticker, :account_id)
      end
    end
  end
end
