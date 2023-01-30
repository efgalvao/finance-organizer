module Investments
  module Treasury
    class NegotiationsController < ApplicationController
      def index
        @negotiations = policy_scope(Investments::Treasury::Negotiation).where(treasury_id: params[:treasury_id])
      end

      def new
        @treasury = Investments::Treasury::Treasury.find(params[:treasury_id])
        @negotiation = @treasury.negotiations.build
      end

      def create
        @negotiation = Investments::Treasury::CreateNegotiation.call(negotiation_params)
        redirect_to treasury_path(id: negotiation_params[:treasury_id]),
                    notice: 'Negotiation successfully created.'
      rescue StandardError
        redirect_to treasury_path(id: negotiation_params[:treasury_id]),
                    notice: 'Negotiation not created.'
      end

      private

      def negotiation_params
        params.require(:negotiation).permit(:date, :invested, :kind,
                                            :shares).merge(treasury_id: params[:treasury_id])
      end
    end
  end
end
