module Account
  class AccountsController < ApplicationController
    before_action :set_account, only: %i[show edit update destroy month_transactions transactions]

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
      @account = current_user.accounts.new(account_params)

      respond_to do |format|
        if @account.save
          format.html { redirect_to @account, notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize(@account)

      respond_to do |format|
        if @account.update(name: account_params[:name])
          format.html { redirect_to @account, notice: 'Account was successfully updated.' }
          format.json { render :show, status: :ok, location: @account }
        else
          format.html { render :edit }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize(@account)

      @account.destroy
      redirect_to accounts_path, notice: 'Account was successfully removed.'
    end

    def month_transactions
      authorize(@account)
    end

    def transactions
      authorize(@account)
    end

    private

    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :balance, :savings, :user_id)
    end
  end
end
