module Transactions
  class CreateTransference < ApplicationService
    def initialize(params)
      @params = params
      @sender = Account.find(params[:sender_id])
      @receiver = Account.find(params[:receiver_id])
    end

    def perform
      transference = Transference.new(params)
      Account.transaction do
        Transaction.create(account: sender, value: transference.amount, kind: 'transfer',
                           title: "Transference to #{receiver.name}", date: transference.date)
        sender.update_balance(-transference.amount)
        Transaction.create(account: receiver, value: transference.amount, kind: 'transfer',
                           title: "Transference from #{sender.name}", date: transference.date)
        receiver.update_balance(transference.amount)
        transference.save
      end
      transference
    end

    private

    attr_reader :sender, :receiver, :amount, :params
  end
end
