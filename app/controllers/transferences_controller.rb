class TransferencesController < ApplicationController
  def new
    @transference = Transference.new
  end

  def create
    @transference = Transactions::CreateTransference.call(transferences_params)

    if @transference
      redirect_to transferences_path,
                  notice: 'Transference successfully created.'
    else
      render :new
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
