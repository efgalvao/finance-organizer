module Account
  class TransactionsController < ApplicationController
    before_action :set_transaction, only: %i[edit update]

    def index
      @transactions = policy_scope(Transaction).where(account_id: params[:account_id]).current_month.order(date: :desc)
    end

    def new
      @transaction = Transaction.new
    end

    def edit
      authorize @transaction
    end

    def create
      @transaction = Transactions::ProcessTransaction.call(transactions_params)

      if @transaction
        redirect_to account_transactions_path(params[:account_id]), notice: 'Transaction successfully created.'
      else
        render :new
      end
    end

    def update
      authorize @transaction
      if @transaction.update(transactions_params.merge(account_id: @transaction.account_id))
        redirect_to account_transactions_path(@transaction.account.id), notice: 'Transaction successfully updated.'
      else
        render :edit
      end
    end

    private

    def transactions_params
      params.require(:account_transaction).permit(:title, :category_id,
                                                  :value, :kind, :date).merge(account_id: params[:account_id])
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
  end
end
