module Transactions
  class CreateTransference < ApplicationService
    def initialize(params)
      # receber um hash com os parametros
      @params = params
      @sender = Account::Account.find(params[:sender_id])
      @receiver = Account::Account.find(params[:receiver_id])
      @amount = params.fetch(:amount, 0).to_f
      @date = set_date
      @user_id = params.fetch(:user_id)
    end

    def self.call(params)
      new(params).call
    end

    def call
      # refatorar
      ActiveRecord::Base.transaction do
        Transference.create!(transference_params)
        Account::CreateTransaction.call(sender_params)
        Account::CreateTransaction.call(receiver_params)
        Account::UpdateAccountBalance.call(account_id: sender.id, amount: -amount)
        Account::UpdateAccountBalance.call(account_id: receiver.id, amount: amount)
      end
    end

    private

    attr_reader :params, :sender, :receiver, :amount, :date, :user_id

    def transference_params
      { sender_id: sender.id, receiver_id: receiver.id, amount: amount, date: date, user_id: user_id }
    end

    def sender_params
      { account_id: sender.id, value: amount, kind: 'transfer',
        title: "Transference to #{receiver.name}", date: date }
    end

    def receiver_params
      { account_id: receiver.id, value: amount, kind: 'transfer',
        title: "Transference from #{sender.name}", date: date }
    end

    def set_date
      return Time.zone.today if params.fetch(:date, '').empty?

      params.fetch(:date)
    end
  end
end
