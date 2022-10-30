module Transactions
  class ProcessTransference < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      Transactions::CreateTransference.call(params)
    end

    private

    attr_reader :params
  end
end
