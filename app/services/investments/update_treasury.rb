module Investments
  class UpdateTreasury < ApplicationService
    def initialize(params)
      @params = params
    end

    def perform
      update_treasury(params)
    end

    private

    def update_treasury(params)
      ActiveRecord::Base.transaction do
        treasury = Investments::Treasury.find(params[:treasury_id])
        treasury.name = params.fetch(:name) { treasury.name }
        treasury.shares += params.fetch(:shares, 0).to_i
        treasury.invested_value_cents += (params.fetch(:value, 0).to_i * 100)
        treasury.current_value_cents += (params.fetch(:amount, 0).to_i * 100)
        treasury.save
      end
    end

    attr_reader :params
  end
end
