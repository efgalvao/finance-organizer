module Invoices
  class ProcessInvoicePayment < ApplicationService
    def initialize(params)
      @params = params
      @sender_id = params[:sender_id]
      @receiver = Account::Account.find(params[:receiver_id])
      @value = params.fetch(:value, 0).to_f
      @date = set_date
    end

    def self.call(params)
      new(params).call
    end

    def call
      ActiveRecord::Base.transaction do
        Transactions::ProcessTransaction.call(sender_params)
        Transactions::ProcessTransaction.call(receiver_params)
      end
    end

    private

    attr_reader :params, :sender_id, :receiver, :value, :date

    def sender_params
      { account_id: sender_id, value: value, kind: 'expense', receiver: false,
        title: "#{I18n.t('transactions.invoice.invoice_payment')} - #{receiver.name}", date: date }
    end

    def receiver_params
      { account_id: receiver.id, value: value, kind: 'income', receiver: true,
        title: I18n.t('transactions.invoice.invoice_payment'), date: date }
    end

    def set_date
      return Time.zone.today if params.fetch(:date, '').empty?

      params.fetch(:date)
    end
  end
end
