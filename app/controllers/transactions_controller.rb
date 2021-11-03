class TransactionsController < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transactions_params)
    if @transaction.save
      redirect_to trasaction_path(@transaction), notice: 'Transaction succesfully created'
    else
      render :new
    end
  end

  def index
    @transactions = policy_scope(Transaction)
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(params[:transaction])
      redirect_to @transaction, notice: 'Transaction updated sucessfully'
    else
      render :edit
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    if @transaction.destroy
      redirect_to account_path(id: params[:account_id]), notice: 'Transaction sucessfully deleted'
    else
      render :delete
    end
  end

  private

  def transactions_params
    params.require(:transaction).permit(:title, :account_id, :category_id,
                                        :value, :kind, :date)
  end
end
