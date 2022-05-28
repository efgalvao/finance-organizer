module Transactions
  class CreateTransference < ApplicationService
    def initialize(params)
      @params = params
      @sender = Account::Account.find(params[:sender_id])
      @receiver = Account::Account.find(params[:receiver_id])
      @amount = params.fetch(:amount, 0).to_f
      @date = set_date
      @user_id = params.fetch(:user_id)
    end

    def perform
      ActiveRecord::Base.transaction do
        Transference.create(transference_params)
        Account::Transaction.create(sender_params)
        update_account_balance(sender.id, -amount)
        Account::Transaction.create(receiver_params)
        update_account_balance(receiver.id, amount)
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

    def update_account_balance(account_id, value)
      account = Account::Account.find(account_id)
      account.balance_cents += value.to_f * 100
      account.save
    end

    def set_date
      return Time.zone.today if params.fetch(:date).empty?

      params.fetch(:date)
    end
  end
end
