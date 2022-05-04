module Investments
  class NegotiationsController < ApplicationController
    before_action :set_negotiation, only: %i[edit update destroy]

    # def index
    #   @treasuries = policy_scope(Stock).includes(:negotiations).all.order(name: :asc)
    # end

    def new
      @negotiation = Investments::Negotiation.new
    end

    def edit
      authorize @negotiation
    end

    def create
      @negotiation = Investments::Negotiation.new(negotiation_params)
      respond_to do |format|
        if @negotiation.valid?

          format.html { redirect_to negotiations_path, notice: 'Negotiation successfully created.' }
          format.json { render :index, status: :created }
        else
          format.html { render :new }
          format.json { render json: @negotiation.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @negotiation

      respond_to do |format|
        if @negotiation.update(negotiation_params)
          format.html { redirect_to negotiation_path(@negotiation), notice: 'Negotiation successfully updated.' }
          format.json { render :index, status: :ok, location: @negotiation }
        else
          format.html { render :edit }
          format.json { render json: @negotiation.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @negotiation

      @negotiation.destroy
      respond_to do |format|
        format.html { redirect_to negotiations_path, notice: 'Negotiation successfully removed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_negotiation
      @negotiation = Investments::Negotiation.find(params[:id])
    end

    def negotiation_params
      params.require(:negotiation).permit(:aquisition_date, :aquisition_value, :treasury_id, :quantity)
    end
  end
end
