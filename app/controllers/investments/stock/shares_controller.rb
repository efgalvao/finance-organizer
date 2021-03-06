module Investments
  module Stock
    class SharesController < ApplicationController
      before_action :set_stock, only: %i[new create]
      def new
        @share = Investments::Stock::Share.new
      end

      def create
        @share = Investments::Stock::CreateShares.call(share_params)
        if @share
          redirect_to stock_path(id: params[:stock_id]), notice: 'Share successfully created.'
        else
          render :new
        end
      end

      private

      def set_stock
        @stock = Investments::Stock::Stock.find(params[:stock_id])
      end

      def share_params
        params.require(:share).permit(:date, :invested, :quantity).merge(stock_id: params[:stock_id])
      end
    end
  end
end
