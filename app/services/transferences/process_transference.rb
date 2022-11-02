module Transferences
  class ProcessTransference < ApplicationService
    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).call
    end

    def call
      Transferences::CreateTransference.call(params)
    end

    private

    attr_reader :params
  end
end
