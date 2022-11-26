class TransferencesController < ApplicationController
  def new
    @transference = Transference.new
  end

  def create
    @transference = Transferences::ProcessTransference.call(transferences_params)
    if !@transference.nil?
      redirect_to transferences_path,
                  notice: 'Transference successfully created.'
    else
      @transference = Transference.new
      render :new,
             notice: 'Transference not created.'
    end
  end

  def index
    @transferences = policy_scope(Transference).current_month.order(date: :desc)
  end

  private

  def transferences_params
    params.require(:transference).permit(:value, :sender_id, :receiver_id, :date)
          .merge(user_id: current_user.id)
  end
end
