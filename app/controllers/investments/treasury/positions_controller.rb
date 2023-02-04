module Investments
  module Treasury
    class PositionsController < ApplicationController
      before_action :set_treasury_and_position, only: %i[create new]
      def new; end

      def create
        @position = Investments::Treasury::CreatePosition.call(position_params)
        redirect_to treasury_path(id: position_params[:treasury_id]),
                    notice: 'Position successfully created.'
      rescue StandardError
        redirect_to treasury_path(id: params[:treasury_id]),
                    notice: 'Position not created.'
      end

      private

      def set_treasury_and_position
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @position = Investments::Treasury::Position.new(treasury_id: params[:treasury_id])
      end

      def position_params
        params.require(:position).permit(:date, :amount,
                                         :treasury_id).merge(treasury_id: params[:treasury_id])
      end
    end
  end
end
