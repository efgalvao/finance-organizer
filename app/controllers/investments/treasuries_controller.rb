module Investments
  class TreasuriesController < ApplicationController
    before_action :set_treasury, only: %i[show edit update destroy]

    def index
      @treasuries = policy_scope(Investments::Treasury).all.includes(:positions).order(name: :asc)
    end

    def show
      authorize @treasury
    end

    def new
      @treasury = Investments::Treasury.new
    end

    def create
      @treasury = Investments::CreateTreasury.new(treasury_params).perform
      if @treasury
        redirect_to account_path(id: treasury_params['account_id']),
                    notice: 'Treasury successfully created.'
      else
        render :new
      end
    end

    def edit
      authorize @treasury
    end

    def update
      authorize @treasury
      @updated_treasury = Investments::UpdateTreasury.new(treasury_params.merge(treasury_id: params[:id])).perform

      if @updated_treasury
        redirect_to investments_treasury_path(id: params[:id]),
                    notice: 'Treasury successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      authorize @treasury

      return unless @treasury.destroy

      redirect_to account_path(id: @treasury.account_id),
                  notice: 'Treasury successfully removed.'
    end

    private

    def set_treasury
      @treasury = Investments::Treasury.find(params[:id])
    end

    def treasury_params
      # TODO: change param to only treasury
      params.require(:investments_treasury).permit(:name, :account_id)
    end
  end
end
