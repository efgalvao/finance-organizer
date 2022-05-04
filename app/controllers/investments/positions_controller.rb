module Investments
  class PositionsController < ApplicationController
    before_action :set_position, only: %i[edit update destroy]

    # def index
    #   @treasuries = policy_scope(Stock).includes(:positions).all.order(name: :asc)
    # end

    def new
      @position = Investments::Position.new
    end

    def edit
      authorize @position
    end

    def create
      @position = Investments::Position.new(position_params)
      respond_to do |format|
        if @position.valid?

          format.html { redirect_to positions_path, notice: 'Position successfully created.' }
          format.json { render :index, status: :created }
        else
          format.html { render :new }
          format.json { render json: @position.errors, status: :unprocessable_entity }
        end
      end
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
      params.require(:position).permit(:aquisition_date, :aquisition_value, :treasury_id, :quantity)
    end
  end
end
