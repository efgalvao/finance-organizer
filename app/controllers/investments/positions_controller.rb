module Investments
  class PositionsController < ApplicationController
    def new
      @position = Investments::Position.new(treasury_id: params[:treasury_id])
    end

    def create
      @position = Investments::CreatePosition.new(position_params).perform

      if @position
        # binding.pry
        redirect_to investments_treasury_path(id: position_params[:treasury_id]),
                    notice: 'Position successfully created.'
      else
        render :new
      end
    end

    private

    def set_position
      @position = Investments::Position.find(params[:id])
    end

    def position_params
      params.require(:investments_position).permit(:date, :amount, :treasury_id)
    end
  end
end
