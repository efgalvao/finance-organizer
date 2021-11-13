class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]

  def new
    @transaction = Transaction.new
  end

  def edit; end

  def show; end

  def create
    @transaction = Transaction.new(transactions_params)
    if @transaction.save
      redirect_to transaction_path(@transaction), notice: 'Transaction succesfully created'
    else
      render :new
    end
  end

  def index
    @transactions = policy_scope(Transaction).current_month
  end

  def update
    if @transaction.update(transactions_params)
      redirect_to @transaction, notice: 'Transaction updated sucessfully'
    else
      render :edit
    end
  end

  def destroy
    if @transaction.destroy
      redirect_to transactions_path(id: params[:account_id]), notice: 'Transaction sucessfully deleted'
    else
      render :delete
    end
  end

  private

  def transactions_params
    params.require(:transaction).permit(:title, :account_id, :category_id,
                                        :value, :kind, :date)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
