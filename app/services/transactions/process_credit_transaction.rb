module Transactions
  class ProcessCreditTransaction < ApplicationService
    def initialize(params)
      @params = params
      @parcels = params.fetch(:parcels, 1).to_i
      @date = set_date
    end

    def self.call(params)
      new(params).call
    end

    def call
      ActiveRecord::Base.transaction do
        if parcels == 1
          process_transaction(params)
        else
          parcels.times do |parcel|
            transaction = build_transaction(parcel)
            process_transaction(transaction)
          end
        end
      end
    end

    private

    attr_reader :params, :date, :parcels

    def build_transaction(parcel)
      {
        title: params.fetch(:title) + " - #{I18n.t('parcel')} #{parcel + 1}/#{parcels}",
        category_id: params.fetch(:category_id),
        account_id: params.fetch(:account_id),
        kind: params.fetch(:kind),
        value: params.fetch(:value).to_f / parcels,
        date: Date.parse(date) + parcel.months
      }
    end

    def process_transaction(transaction)
      Transactions::ProcessTransaction.call(transaction)
    end

    def set_date
      return Time.zone.today if params.fetch(:date) == ''

      params.fetch(:date)
    end
  end
end
