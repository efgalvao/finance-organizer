class StocksController < ApplicationController
  before_action :set_stock, only: %i[show edit update destroy summary]

  def index
    @stocks = policy_scope(Stock).all.includes(:prices).order(name: :asc)
  end

  def show
    authorize @stock
  end

  def new
    @stock = Stock.new
  end

  def edit
    authorize @stock
  end

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
    authorize @stock

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
    authorize @stock

    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock successfully removed.' }
      format.json { head :no_content }
    end
  end

  def summary
    authorize @stock
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :account_id)
  end
end
