class DividendsController < ApplicationController
  before_action :set_dividend, only: %i[show edit update destroy]

  # GET /dividends
  # GET /dividends.json
  def index
    @stocks = policy_scope(Stock).includes(:dividends).order(name: :asc)
  end

  # GET /dividends/1
  # GET /dividends/1.json
  def show; end

  # GET /dividends/new
  def new
    @dividend = Dividend.new
  end

  # GET /dividends/1/edit
  def edit; end

  # POST /dividends
  # POST /dividends.json
  def create
    @dividend = Dividend.new(dividend_params)

    respond_to do |format|
      if @dividend.save
        format.html { redirect_to dividends_path, notice: 'Dividend successfully created.' }
        format.json { render :show, status: :created, location: @dividend }
      else
        format.html { render :new }
        format.json { render json: @dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dividends/1
  # PATCH/PUT /dividends/1.json
  def update
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

  # DELETE /dividends/1
  # DELETE /dividends/1.json
  def destroy
    @dividend.destroy
    respond_to do |format|
      format.html { redirect_to dividends_path, notice: 'Dividend successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dividend
    @dividend = Dividend.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dividend_params
    params.require(:dividend).permit(:date, :value, :stock_id)
  end
end
