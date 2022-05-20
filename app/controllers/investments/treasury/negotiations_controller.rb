module Investments
  module Treasury
    class NegotiationsController < ApplicationController
      def index
        @negotiations = policy_scope(Investments::Treasury::Negotiation).includes(:treasury).all
      end

      def new
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @negotiation = @treasury.negotiations.build
      end

      def create
        @negotiation = Investments::Treasury::CreateNegotiation.new(negotiation_params).perform

        if @negotiation
          redirect_to investments_treasury_path(id: negotiation_params[:treasury_id]),
                      notice: 'Negotiation successfully created.'
        else
          render :new
        end
      end

      private

      def negotiation_params
        params.require(:investments_negotiation).permit(:date, :invested, :kind,
                                                        :shares).merge(treasury_id: params[:treasury_id])
      end
    end
  end
end
