class SharesController < ApplicationController
  before_action :set_share, only: %i[show edit update destroy]

  # GET /shares
  # GET /shares.json
  def index
    @stocks = policy_scope(Stock).includes(:shares).all.order(name: :asc)
  end

  # GET /shares/1
  # GET /shares/1.json
  def show; end

  # GET /shares/new
  def new
    @share = Share.new
  end

  # GET /shares/1/edit
  def edit; end

  # POST /shares
  # POST /shares.json
  def create
    @share = Share.new(share_params)
    quantity = params[:quantity].to_i - 1
    respond_to do |format|
      if @share.save
        Share.transaction do
          quantity.times { Share.create(share_params) }
        end
        format.html { redirect_to shares_path, notice: 'Share successfully created.' }
        format.json { render :show, status: :created, location: @share }
      else
        format.html { render :new }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shares/1
  # PATCH/PUT /shares/1.json
  def update
    respond_to do |format|
      if @share.update(share_params)
        format.html { redirect_to share_path(@share), notice: 'Share successfully updated.' }
        format.json { render :show, status: :ok, location: @share }
      else
        format.html { render :edit }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shares/1
  # DELETE /shares/1.json
  def destroy
    @share.destroy
    respond_to do |format|
      format.html { redirect_to shares_path, notice: 'Share successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = Share.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def share_params
    params.require(:share).permit(:aquisition_date, :aquisition_value, :stock_id, :quantity)
  end
end
