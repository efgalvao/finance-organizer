module Account
  class BalancesController < ApplicationController
    def index
      account = policy_scope(Account).find(params[:account_id])
      @balances = account.balances.order(date: :desc)
    end

    def new
      @balance = Balance.new
    end

    def create
      @balance = CreateBalance.call(balance_params)

      if @balance.valid?
        redirect_to account_path(@balance.account.id), notice: 'Balance successfully created.'
      else
        render :new
      end
    end

    private

    def balance_params
      params.require(:balance).permit(:balance, :date).merge(account_id: params[:account_id])
    end
  end
end
