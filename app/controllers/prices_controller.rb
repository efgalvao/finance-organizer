class PricesController < ApplicationController
  before_action :set_price, only: %i[edit update destroy]
  before_action :set_stock, only: %i[current_price]

  def index
    @stocks = policy_scope(Stock).includes(:prices).all.order(name: :asc)
  end

  def new
    @price = Price.new
  end

  def edit
    authorize @price
  end

  def create
    @price = Price.new(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to prices_path, notice: 'Price successfully created.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @price

    respond_to do |format|
      if @price.update(price_params)
        format.html do
          redirect_to price_path(@price), notice: 'Price successfully updated.'
        end
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @price

    @price.destroy
    respond_to do |format|
      format.html do
        redirect_to prices_path, notice: 'Price successfully removed.'
      end
      format.json { head :no_content }
    end
  end

  def current_price
    new_price = PriceUpdater.get_price(@stock.name)
    @stock.prices.new(price: new_price)

    if @stock.save
      redirect_to stock_summary_path(@stock), notice: 'Price successfully updated.'
    else
      redirect_to stock_summary_path(@stock), notice: 'Price not updated.'
    end
  end

  private

  def set_price
    @price = Price.find(params[:id])
  end

  def set_stock
    @stock = Stock.find(params[:stock_id])
  end

  def price_params
    params.require(:price).permit(:date, :price, :stock_id)
  end
end
