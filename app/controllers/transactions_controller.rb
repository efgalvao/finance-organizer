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
      respond_to do |format|
        format.html do
          redirect_to transaction_path(@transaction),
                      notice: 'Transaction successfully created.'
        end
        format.json { render json: @transaction, status: :created }
      end

    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @transactions = policy_scope(Transaction).current_month.order(date: :desc)
  end

  def update
    if @transaction.update(transactions_params)
      respond_to do |format|
        format.html do
          redirect_to @transaction,
                      notice: 'Transaction successfully updated.'
        end
        format.json { render json: @transaction, status: :ok }
      end

    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @transaction.destroy
      respond_to do |format|
        format.html do
          redirect_to transactions_path(id: params[:account_id]),
                      notice: 'Transaction successfully removed.'
        end
        format.json { head :no_content, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :delete }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
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
