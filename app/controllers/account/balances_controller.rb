module Account
  class BalancesController < ApplicationController
    before_action :set_balance, only: %i[show edit update destroy]

    def index
      @accounts = policy_scope(Account).order(name: :asc).all
    end

    def show
      authorize(@balance)
    end

    def new
      @balance = Balance.new
    end

    def edit
      authorize(@balance)
    end

    def create
      @balance = Balance.new(balance_params)
      respond_to do |format|
        if @balance.save
          format.html { redirect_to balances_path, notice: 'Balance was successfully created.' }
          format.json { render :show, status: :created, location: @balance }
        else
          format.html { render :new }
          format.json { render json: @balance.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize(@balance)

      respond_to do |format|
        if @balance.update(balance_params)
          format.html { redirect_to @balance, notice: 'Balance was successfully updated.' }
          format.json { render :show, status: :ok, location: @balance }
        else
          format.html { render :edit }
          format.json { render json: @balance.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize(@balance)

      @balance.destroy
      respond_to do |format|
        format.html { redirect_to balances_path, notice: 'Balance was successfully removed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_balance
      @balance = Balance.find(params[:id])
    end

    def balance_params
      params.require(:balance).permit(:balance, :date, :account_id)
    end
  end
end
