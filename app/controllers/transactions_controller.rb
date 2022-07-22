class TransactionsController < ApplicationController
  def create
    @transaction = Transactions::ProcessCreditTransaction.call(transactions_params)

    if @transaction
      redirect_to account_path(id: transactions_params[:account_id]), notice: 'Transaction successfully created.'
    else
      render :debit
    end
  end

  def debit
    @transaction = Account::Transaction.new
  end

  def credit
    @transaction = Account::Transaction.new
  end

  def income
    @transaction = Account::Transaction.new
  end

  def invoice_payment
    Transactions::ProcessInvoicePayment.call(invoice_params)
    @user = current_user
    render 'users/summary'
  end

  private

  def transactions_params
    params.require(:transaction).permit(:title, :category_id, :account_id, :kind,
                                        :value, :parcels, :date)
  end

  def invoice_params
    params.require(:invoice_payment).permit(:value, :sender_id, :receiver_id, :date)
  end
end
