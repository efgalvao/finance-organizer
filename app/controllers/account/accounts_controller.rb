module Account
  class AccountsController < ApplicationController
    before_action :set_account, only: %i[show edit update destroy]

    def index
      @accounts = policy_scope(Account).order(name: :asc)
    end

    def show
      authorize(@account)
    end

    def new
      @account = Account.new
    end

    def edit
      authorize(@account)
    end

    def create
      @account = Account::CreateAccount.new(account_params)

      if @account.save
        redirect_to account_path(@account), notice: 'Account successfully created.'
      else
        render :new
      end
    end

    def update
      authorize(@account)

      if @account.update(name: params[:account][:name])
        redirect_to account_path(@account), notice: 'Account successfully updated.'
      else
        render :edit

      end
    end

    def destroy
      authorize(@account)

      @account.destroy
      redirect_to accounts_path, notice: 'Account successfully removed.'
    end

    private

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :balance, :savings).merge(user_id: current_user.id)
    end
  end
end
