module Investments
  module Stock
    class SharesController < ApplicationController
      def new
        @share = Share.new
      end

      def create
        @share = Transactions::CreateInvestment.perform(share_params, params[:quantity].to_i)
        if @share.valid?
          redirect_to shares_path, notice: 'Share successfully created.'
        else
          render :new
        end
      end

      private

      def share_params
        params.require(:share).permit(:aquisition_date, :aquisition_value, :stock_id, :quantity)
      end
    end
  end
end
