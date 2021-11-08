class ChartsController < ApplicationController
  def index
    @accounts = policy_scope(Account).includes(:stocks).order('name asc').all
  end

  def show
    @stock = Stock.find_by(params[:stock_id])
  end
end
