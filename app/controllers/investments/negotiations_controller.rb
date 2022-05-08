module Investments
  class NegotiationsController < ApplicationController
    def index
      @negotiations = policy_scope(Investments::Negotiation).includes(:treasury).all
    end

    def new
      @treasury = Investments::Treasury.find(params[:treasury_id])
      @negotiation = @treasury.negotiations.build
      # @negotiation = Investments::Negotiation.new
    end

    def create
      @negotiation = Investments::CreateNegotiation.new(negotiation_params).perform
      if @negotiation
        redirect_to investments_treasury_path(id: negotiation_params[:treasury_id]),
                    notice: 'Negotiation successfully created.'
      else
        format.html { render :new }
      end
    end

    private

    def negotiation_params
      params.require(:investments_negotiation).permit(:date, :value, :kind, :shares, :treasury_id)
    end
  end
end
