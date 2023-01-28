class TransactionsController < ApplicationController
  def create
    @transaction = Transactions::ProcessCreditTransaction.call(transactions_params)

    redirect_to account_path(id: transactions_params[:account_id]), notice: 'Transaction successfully created.'
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = 'Transaction not created.'
    render :debit
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
    Invoices::ProcessInvoicePayment.call(invoice_params)
    @user = UserPresenter.new(current_user)
    redirect_to user_summary_url, notice: 'Invoice paid successfully.'
  rescue StandardError => e
    @user = UserPresenter.new(current_user)
    redirect_to user_summary_url, notice: 'Invoice not paid.', status: :unprocessable_entity
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
