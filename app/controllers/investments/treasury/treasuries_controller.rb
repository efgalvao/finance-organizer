module Investments
  module Treasury
    class TreasuriesController < ApplicationController
      before_action :set_treasury, only: %i[show edit update destroy release release_form]

      def index
        @treasuries = policy_scope(Investments::Treasury::Treasury)
                      .where(released_at: nil)
                      .includes(:positions).order(name: :asc)
      end

      def show
        authorize @treasury
      end

      def new
        @account = Account::Account.find(params[:account_id])
        @treasury = Investments::Treasury::Treasury.new
      end

      def create
        @treasury = Investments::Treasury::CreateTreasury.call(treasury_params)
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
        @updated_treasury = Investments::Treasury::UpdateTreasury.call(treasury_params)

        if @updated_treasury
          redirect_to treasury_path(id: params[:id]),
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

      def release_form
        # binding.pry
        authorize @treasury

        # Investments::Treasury::ReleaseTreasury.call(@treasury)

        # redirect_to account_path(id: @treasury.account_id),
        #             notice: 'Treasury successfully released.'
      end

      def release
        # binding.pry
        authorize @treasury

        Investments::Treasury::ReleaseTreasury.call(release_params)

        redirect_to account_path(id: @treasury.account_id),
                    notice: 'Treasury successfully released.'
      end

      private

      def set_treasury
        @treasury = Investments::Treasury::Treasury.find(params[:id])
      end

      def treasury_params
        params.require(:treasury).permit(:name, :account_id).merge(treasury_id: params[:id])
      end

      def release_params
        params.require(:treasury).permit(:released_at, :released_value).merge(treasury_id: params[:id])
      end
    end
  end
end
