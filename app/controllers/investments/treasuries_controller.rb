module Investments
  class TreasuriesController < ApplicationController
    before_action :set_treasury, only: %i[show edit update destroy summary]

    def index
      @treasuries = policy_scope(Investments::Treasury).all.includes(:positions).order(name: :asc)
    end

    def show
      authorize @treasury
    end

    def new
      @treasury = Investments::Treasury.new
    end

    def edit
      authorize @treasury
    end

    def create
      @treasury = Investments::Treasury.new(treasury_params)

      respond_to do |format|
        if @treasury.save
          format.html { redirect_to @treasury, notice: 'Treasury successfully created.' }
          format.json { render :show, status: :created, location: @treasury }
        else
          format.html { render :new }
          format.json { render json: @treasury.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @treasury

      respond_to do |format|
        if @treasury.update(name: treasury_params[:name])
          format.html { redirect_to @treasury, notice: 'Treasury successfully updated.' }
          format.json { render :show, status: :ok, location: @treasury }
        else
          format.html { render :edit }
          format.json { render json: @treasury.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @treasury

      @streasury.destroy
      respond_to do |format|
        format.html { redirect_to treasury_url, notice: 'Treasure successfully removed.' }
        format.json { head :no_content }
      end
    end

    def summary
      authorize @treasury
    end

    private

    def set_treasury
      @treasury = Investments::Treasury.find(params[:id])
    end

    def stock_params
      params.require(:stock).permit(:name, :account_id)
    end
  end
end
