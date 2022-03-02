class StocksController < ApplicationController
  before_action :set_stock, only: %i[show edit update destroy]

  def index
    @stocks = policy_scope(Stock).all.order(name: :asc)
  end

  def show; end

  def new
    @stock = Stock.new
  end

  def edit; end

  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock.update(name: stock_params[:name])
        format.html { redirect_to @stock, notice: 'Stock successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock successfully removed.' }
      format.json { head :no_content }
    end
  end

  def summary
    @stock = Stock.find(params[:stock_id])
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :account_id)
  end
end
