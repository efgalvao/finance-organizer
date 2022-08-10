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

    def self.call(params)
      new(params).call
    end

    def call
      transference = Transference.new(transference_params)
      ActiveRecord::Base.transaction do
        transference.save!
        Transactions::ProcessTransaction.call(sender_params)
        Transactions::ProcessTransaction.call(receiver_params)
      end
    rescue StandardError
      transference
    end

    private

    attr_reader :params, :sender, :receiver, :amount, :date, :user_id

    def transference_params
      { sender_id: sender.id, receiver_id: receiver.id, amount: amount, date: date,
        user_id: user_id }
    end

    def sender_params
      { account_id: sender.id, value: amount, kind: 'transfer', receiver: false,
        title: "Transference to #{receiver.name}", date: date }
    end

    def receiver_params
      { account_id: receiver.id, value: amount, kind: 'transfer', receiver: true,
        title: "Transference from #{sender.name}", date: date }
    end

    def set_date
      return Time.zone.today if params.fetch(:date, '').empty?

      params.fetch(:date)
    end
  end
end
