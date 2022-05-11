class DividendsController < ApplicationController
  before_action :set_dividend, only: %i[show edit update destroy]

  def index
    @stocks = policy_scope(Dividend)
  end

  def show
    authorize @dividend
  end

  def new
    @dividend = Dividend.new
  end

  def edit
    authorize @dividend
  end

  def create
    @dividend = Dividend.create(dividend_params)

    respond_to do |format|
      if @dividend.valid?
        format.html { redirect_to dividends_path, notice: 'Dividend successfully created.' }
        format.json { render :show, status: :created, location: @dividend }
      else
        format.html { render :new }
        format.json { render json: @dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @dividend

    respond_to do |format|
      if @dividend.update(dividend_params)
        format.html { redirect_to dividend_path(@dividend), notice: 'Dividend successfully updated.' }
        format.json { render :show, status: :ok, location: @dividend }
      else
        format.html { render :edit }
        format.json { render json: @dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @dividend

    @dividend.destroy
    respond_to do |format|
      format.html { redirect_to dividends_path, notice: 'Dividend successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_dividend
    @dividend = Dividend.find(params[:id])
  end

  def dividend_params
    params.require(:dividend).permit(:date, :value, :stock_id)
  end
end
