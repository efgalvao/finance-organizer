module Investments
  class PositionsController < ApplicationController
    before_action :set_position, only: %i[edit update destroy]

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

    def edit
      authorize @position
    end

    def update
      authorize @position

      respond_to do |format|
        if @position.update(position_params)
          format.html { redirect_to position_path(@position), notice: 'Position successfully updated.' }
          format.json { render :index, status: :ok, location: @position }
        else
          format.html { render :edit }
          format.json { render json: @position.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @position

      @position.destroy
      respond_to do |format|
        format.html { redirect_to positions_path, notice: 'Position successfully removed.' }
        format.json { head :no_content }
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
