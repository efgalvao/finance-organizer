module Investments
  class CreateNegotiation < ApplicationService
    def initialize(params)
      @params = params
    end

    def perform
      create_negotiation(params)
    end

    private

    def create_negotiation(params)
      ActiveRecord::Base.transaction do
        Investments::Negotiation.create(params)
        Investments::UpdateTreasury.new(params).perform
      end
    end

    attr_reader :params
  end
end
