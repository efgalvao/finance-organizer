module Transactions
  class ProcessTransference < ApplicationService
    def initialize(params)
      @params = params
      @sender = Account::Account.find(params[:sender_id])
      @receiver = Account::Account.find(params[:receiver_id])
    end

    def self.call(params)
      new(params).call
    end

    def call
      # tratar retorno no controller
      return 'Sender and receiver are the same' if sender == receiver

      Transactions::CreateTransference.call(params)
    end

    private

    attr_reader :params, :sender, :receiver
  end
end
