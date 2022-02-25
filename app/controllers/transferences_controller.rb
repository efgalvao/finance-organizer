class TransferencesController < ApplicationController
  def new
    @transference = Transference.new
  end

  def create
    @transference = ExecuteTransference.perform(transferences_params)
    @transference.save
    if @transference.save
      respond_to do |format|
        format.html do
          redirect_to transferences_path,
                      notice: 'Transference successfully created.'
        end
        format.json { render json: @transference, status: :created }
      end

    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @transference.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @transferences = policy_scope(Transference).current_month.order(date: :desc)
  end

  private

  def transferences_params
    params.require(:transference).permit(:amount, :sender_id, :receiver_id, :date)
          .merge(user_id: current_user.id)
  end
end
