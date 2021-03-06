module Investments
  module Treasury
    class PositionsController < ApplicationController
      def new
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @position = Investments::Treasury::Position.new(treasury_id: params[:treasury_id])
      end

      def create
        @position = Investments::Treasury::CreatePosition.call(position_params)

        if @position
          redirect_to treasury_path(id: position_params[:treasury_id]),
                      notice: 'Position successfully created.'
        else
          render :new
        end
      end

      private

      def position_params
        params.require(:position).permit(:date, :amount,
                                         :treasury_id).merge(treasury_id: params[:treasury_id])
      end
    end
  end
end
