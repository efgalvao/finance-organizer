class TransactionsController < ApplicationController
  def create
    @transaction = Transactions::ProcessTransaction.call(transactions_params)

    if @transaction
      redirect_to account_path(id: transactions_params[:account_id]), notice: 'Transaction successfully created.'
    else
      render :debit
    end
  end

  def debit
    @transaction = Account::Transaction.new(kind: 'expense')
  end

  def credit
    @transaction = Account::Transaction.new(kind: 'expense')
  end

  def income
    @transaction = Account::Transaction.new(kind: 'income')
  end

  private

  def transactions_params
    params.require(:transaction).permit(:title, :category_id, :account_id,
                                        :value, :date)
  end
end
