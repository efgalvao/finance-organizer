class SharesController < ApplicationController
  before_action :set_share, only: %i[edit update destroy]

  def index
    @stocks = policy_scope(Stock).includes(:shares).all.order(name: :asc)
  end

  def new
    @share = Share.new
  end

  def edit
    authorize @share
  end

  def create
    @share = Transactions::CreateInvestment.perform(share_params, params[:quantity].to_i)
    respond_to do |format|
      if @share.valid?

        format.html { redirect_to shares_path, notice: 'Share successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @share

    respond_to do |format|
      if @share.update(share_params)
        format.html { redirect_to share_path(@share), notice: 'Share successfully updated.' }
        format.json { render :index, status: :ok, location: @share }
      else
        format.html { render :edit }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @share

    @share.destroy
    respond_to do |format|
      format.html { redirect_to shares_path, notice: 'Share successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_share
    @share = Share.find(params[:id])
  end

  def share_params
    params.require(:share).permit(:aquisition_date, :aquisition_value, :stock_id, :quantity)
  end
end
