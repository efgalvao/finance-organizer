module Investments
  module Stock
    class SharesController < ApplicationController
      before_action :set_stock, only: %i[new create sell]
      def new
        @share = Investments::Stock::Share.new
      end

      def create
        @share = Investments::Stock::CreateShares.call(share_params)
        if @share
          redirect_to stock_path(id: params[:stock_id]), notice: 'Share successfully created.'
        else
          redirect_to stock_path(id: params[:stock_id]), notice: 'Share not created.'
        end
      end

      def sell_shares
        response = Investments::Stock::SellShares.call(sell_shares_params)

        if response
          redirect_to stock_path(id: params[:stock_id]), notice: 'Share successfully sold.'
        else
          redirect_to stock_path(id: params[:stock_id]), notice: 'Share not sold.'
        end
      end

      def sell; end

      private

      def set_stock
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def share_params
        params.require(:share).permit(:date, :invested, :quantity).merge(stock_id: params[:stock_id])
      end

      def sell_shares_params
        params.require(:sell).permit(:date, :received, :quantity).merge(stock_id: params[:stock_id])
      end
    end
  end
end
